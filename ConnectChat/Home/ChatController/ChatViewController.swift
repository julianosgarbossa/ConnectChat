//
//  ChatViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    private var chatScreen: ChatScreen?
    private var alert: Alert?
    private var listMessage:[Message] = []
    private var idUserLogged: String?
    private var contact: Contact?
    private var messageListener: ListenerRegistration?
    private var auth: Auth?
    private var firestore: Firestore?
    private var nameContact: String?
    private var nameUserLogged: String?
    
    override func loadView() {
        chatScreen = ChatScreen()
        self.view = chatScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = Alert(controller: self)
        self.setProtocols()
        self.configDataFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addListenerRecoveryMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.messageListener?.remove()
    }
    
    private func setProtocols() {
        chatScreen?.delegate(delegate: self)
        chatScreen?.chatNavScreenDelegate(delegate: self)
        chatScreen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
    
    private func configDataFirebase() {
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        if let displayName = auth?.currentUser?.displayName, (nameUserLogged ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nameUserLogged = displayName
        }
        
        // recuperar id do usuario logado
        if let id = auth?.currentUser?.uid {
            idUserLogged = id
            self.recoveryDataUserLogged()
        }
        
        if let name = contact?.name {
            nameContact = name
        }
    }

    public func configure(contact: Contact) {
        self.contact = contact
        self.nameContact = contact.name
    }
    
    private func addListenerRecoveryMessages() {
        guard let idUserLogged = idUserLogged,
              let idDestination = contact?.id else {
            return
        }
        
        messageListener = firestore?
            .collection("messages")
            .document(idUserLogged)
            .collection(idDestination)
            .order(by: "date", descending: true)
            .addSnapshotListener({ snapshotResult, error in
                guard error == nil else {
                    return
                }
                
                var recoveredMessages: [Message] = []
                
                if let snapshot = snapshotResult?.documents {
                    for document in snapshot {
                        let data = document.data()
                        let message = Message(id: document.documentID, dictionary: data)
                        recoveredMessages.append(message)
                    }
                }
                
                DispatchQueue.main.async {
                    self.listMessage = recoveredMessages
                    self.chatScreen?.reloadTableView()
                }
            })
    }
    
    private func recoveryDataUserLogged() {
        let users = firestore?.collection("users").document(idUserLogged ?? "")
        users?.getDocument() { documentSnapshot, error in
            if error == nil {
                let data: Contact = Contact(dictionary: documentSnapshot?.data() ?? [:])
                let fetchedName = (data.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                DispatchQueue.main.async {
                    if !fetchedName.isEmpty {
                        self.nameUserLogged = fetchedName
                    }
                    self.chatScreen?.reloadTableView()
                }
            }
        }
    }
    
    private func saveMessage(idRemetente: String, idDestinatario: String, messageId: String, message: [String:Any]) {
        firestore?
            .collection("messages")
            .document(idRemetente)
            .collection(idDestinatario)
            .document(messageId)
            .setData(message)
    }
    
    private func saveConversation(idRemetente: String, idDestinatario: String, conversation: [String:Any]) {
        firestore?.collection("conversation").document(idRemetente).collection("lastConversation").document(idDestinatario).setData(conversation)
    }
    
    private func createMessagePayload(messageId: String, text: String, senderId: String) -> [String: Any] {
        return [
            "id": messageId,
            "idUser": senderId,
            "text": text,
            "date": FieldValue.serverTimestamp(),
            "isEdited": false
        ]
    }
    
    private func presentEditMessageAlert(for message: Message) {
        let alertController = UIAlertController(title: "Editar mensagem", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = message.text
            textField.placeholder = "Digite a nova mensagem"
        }
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { _ in
            let newText = (alertController.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newText.isEmpty {
                self.alert?.getAlert(title: "Atenção", message: "A mensagem não pode ficar vazia.")
                return
            }
            
            if newText == (message.text ?? "") {
                return
            }
            
            self.updateMessage(message, with: newText)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
    
    private func presentDeleteConfirmation(for message: Message) {
        let alertController = UIAlertController(title: "Excluir mensagem", message: "Tem certeza que deseja excluir esta mensagem?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { _ in
            self.deleteMessage(message)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
    
    private func updateMessage(_ message: Message, with newText: String) {
        guard let firestore = firestore,
              let idUserLogged = idUserLogged,
              let idDestination = contact?.id else {
            return
        }
        
        let updates: [String: Any] = [
            "text": newText,
            "isEdited": true
        ]
        let wasLastMessage = isLastMessage(message)
        
        let dispatchGroup = DispatchGroup()
        var updateError: Error?
        
        dispatchGroup.enter()
        firestore
            .collection("messages")
            .document(idUserLogged)
            .collection(idDestination)
            .document(message.id)
            .updateData(updates) { error in
                if let error = error {
                    updateError = error
                }
                dispatchGroup.leave()
            }
        
        dispatchGroup.enter()
        firestore
            .collection("messages")
            .document(idDestination)
            .collection(idUserLogged)
            .document(message.id)
            .updateData(updates) { error in
                if let error = error, !self.isNotFoundError(error) {
                    updateError = error
                }
                dispatchGroup.leave()
            }
        
        dispatchGroup.notify(queue: .main) {
            if let error = updateError {
                self.alert?.getAlert(title: "Erro", message: "Não foi possível editar a mensagem. \(error.localizedDescription)")
                return
            }
            
            if wasLastMessage {
                self.updateConversationLastMessage(text: newText)
            }
        }
    }
    
    private func deleteMessage(_ message: Message) {
        guard let firestore = firestore,
              let idUserLogged = idUserLogged,
              let idDestination = contact?.id else {
            return
        }
        let wasLastMessage = isLastMessage(message)
        let nextLastMessage = nextConversationLastMessage(excluding: message.id)
        
        let dispatchGroup = DispatchGroup()
        var deletionError: Error?
        
        dispatchGroup.enter()
        firestore
            .collection("messages")
            .document(idUserLogged)
            .collection(idDestination)
            .document(message.id)
            .delete { error in
                if let error = error {
                    deletionError = error
                }
                dispatchGroup.leave()
            }
        
        dispatchGroup.enter()
        firestore
            .collection("messages")
            .document(idDestination)
            .collection(idUserLogged)
            .document(message.id)
            .delete { error in
                if let error = error, !self.isNotFoundError(error) {
                    deletionError = error
                }
                dispatchGroup.leave()
            }
        
        dispatchGroup.notify(queue: .main) {
            if let error = deletionError {
                self.alert?.getAlert(title: "Erro", message: "Não foi possível excluir a mensagem. \(error.localizedDescription)")
                return
            }
            
            if wasLastMessage {
                self.updateConversationLastMessage(text: nextLastMessage)
            }
        }
    }
    
    private func updateConversationLastMessage(text: String) {
        guard let firestore = firestore,
              let idUserLogged = idUserLogged,
              let idDestination = contact?.id else {
            return
        }
        
        let data: [String: Any] = [
            "lastMessage": text
        ]
        
        firestore
            .collection("conversation")
            .document(idUserLogged)
            .collection("lastConversation")
            .document(idDestination)
            .setData(data, merge: true)
        
        firestore
            .collection("conversation")
            .document(idDestination)
            .collection("lastConversation")
            .document(idUserLogged)
            .setData(data, merge: true)
    }
    
    private func nextConversationLastMessage(excluding messageId: String) -> String {
        for message in listMessage where message.id != messageId {
            if let text = message.text, !text.isEmpty {
                return text
            }
        }
        return ""
    }
    
    private func isLastMessage(_ message: Message) -> Bool {
        guard let firstMessage = listMessage.first else {
            return false
        }
        return firstMessage.id == message.id
    }
    
    private func isNotFoundError(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == FirestoreErrorDomain && nsError.code == FirestoreErrorCode.notFound.rawValue
    }
}

extension ChatViewController: ChatNavScreenProtocol {
    func actionBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionSearchButton() {
        alert?.getAlert(title: "Atenção", message: "A funcionalidade de pesquisa ainda não foi implementada, tente novamente mais tarde!")
    }
}

extension ChatViewController: ChatScreenProtocol {
    func actionSendButton() {
        let inputMessage = (chatScreen?.getInputMessageText() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !inputMessage.isEmpty,
              let idUserLogged = idUserLogged,
              let idUserDestination = contact?.id else {
            return
        }
        
        let messageId = UUID().uuidString
        let message = createMessagePayload(messageId: messageId, text: inputMessage, senderId: idUserLogged)
        
        // mensagem para remetente
        self.saveMessage(idRemetente: idUserLogged, idDestinatario: idUserDestination, messageId: messageId, message: message)
        
        // mensagem para destinatario
        self.saveMessage(idRemetente: idUserDestination, idDestinatario: idUserLogged, messageId: messageId, message: message)
        
        chatScreen?.clearInputMessage()
        
        let conversationForSender: [String: Any] = [
            "idRemetente": idUserLogged,
            "idUserDestination": idUserDestination,
            "nameUser": nameContact ?? "",
            "lastMessage": inputMessage
        ]
        self.saveConversation(idRemetente: idUserLogged, idDestinatario: idUserDestination, conversation: conversationForSender)
        
        let conversationForRecipient: [String: Any] = [
            "idRemetente": idUserDestination,
            "idUserDestination": idUserLogged,
            "nameUser": nameUserLogged ?? "",
            "lastMessage": inputMessage
        ]
        self.saveConversation(idRemetente: idUserDestination, idDestinatario: idUserLogged, conversation: conversationForRecipient)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard listMessage.indices.contains(indexPath.row) else {
            return nil
        }
        
        let message = listMessage[indexPath.row]
        
        guard message.idUser == idUserLogged else {
            return nil
        }
        
        let actionBackgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        let trashTemplate = UIImage(systemName: "trash")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let editTemplate = UIImage(systemName: "square.and.pencil")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.presentDeleteConfirmation(for: message)
            completion(true)
        }
        deleteAction.backgroundColor = actionBackgroundColor
        deleteAction.image = trashTemplate?.rotated(by: .pi)
        
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            self?.presentEditMessageAlert(for: message)
            completion(true)
        }
        editAction.backgroundColor = actionBackgroundColor
        editAction.image = editTemplate?.rotated(by: .pi)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let dados = listMessage[index]
        let idUser = dados.idUser ?? ""
        
        let senderDisplayName = senderDisplayName(for: dados)
        
        if self.idUserLogged != idUser {
            // lado esquerdo
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: dados, senderDisplayName: senderDisplayName)
            cell.selectionStyle = .none
            return cell
        } else {
            // lado direito
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: dados, senderDisplayName: senderDisplayName)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = listMessage[indexPath.row]
        let messageFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        let senderFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        let textHeight = max(message.displayText.heightWithConstrainedWidth(width: 220, font: messageFont), messageFont.lineHeight)
        let senderHeight = senderDisplayName(for: message).heightWithConstrainedWidth(width: 220, font: senderFont)
        return CGFloat(60 + textHeight + senderHeight)
    }
}

private extension ChatViewController {
    func senderDisplayName(for message: Message) -> String {
        let isCurrentUser = message.idUser == idUserLogged
        if isCurrentUser {
            let trimmedName = (nameUserLogged ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedName.isEmpty {
                return "Você:"
            }
            if trimmedName.compare("Você", options: .caseInsensitive) == .orderedSame {
                return "Você:"
            }
            return "\(trimmedName) (Você):"
        } else {
            let contactName = (nameContact ?? contact?.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if contactName.isEmpty {
                return "Contato:"
            }
            return "\(contactName):"
        }
    }
}

private extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            cgContext.translateBy(x: size.width / 2, y: size.height / 2)
            cgContext.rotate(by: radians)
            draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        }.withRenderingMode(renderingMode)
    }
}
