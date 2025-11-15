//
//  RegisterViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 11/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

private enum RegisterError: LocalizedError {
    case storageUnavailable
    case imageDataUnavailable
    case userUnavailable
    
    var errorDescription: String? {
        switch self {
        case .storageUnavailable:
            return "Não foi possível acessar o armazenamento."
        case .imageDataUnavailable:
            return "Não foi possível preparar a imagem de perfil."
        case .userUnavailable:
            return "Informações do usuário não estão disponíveis."
        }
    }
}

class RegisterViewController: UIViewController {

    private var registerScreen: RegisterScreen?
    private var alert: Alert?
    private var auth: Auth?
    private var firestore: Firestore?
    private var storage: Storage?
    private var selectedProfileImage: UIImage?
    
    override func loadView() {
        registerScreen = RegisterScreen()
        self.view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        self.alert = Alert(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerScreen?.validateTextFields()
    }
    
    private func setDelegates() {
        registerScreen?.configTextFieldDelegate(delegate: self)
        registerScreen?.delegate(delegate: self)
    }
    
    private func profileImageDataToUpload() -> Data? {
        if let image = selectedProfileImage {
            return image.jpegData(compressionQuality: 0.8)
        }
        if let defaultImage = registerScreen?.getDefaultProfileImage() {
            return defaultImage.jpegData(compressionQuality: 0.8)
        }
        return nil
    }
    
    private func uploadProfileImage(for userId: String, completion: @escaping (Result<(String, StorageReference), Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(RegisterError.storageUnavailable))
            return
        }
        
        guard let imageData = profileImageDataToUpload() else {
            completion(.failure(RegisterError.imageDataUnavailable))
            return
        }
        
        let imageReference = storage.reference().child("profileImages/\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageReference.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success((imageReference.fullPath, imageReference)))
        }
    }
    
    private func saveUserDocument(idUser: String, name: String, email: String, photoPath: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "id": idUser,
            "name": name,
            "email": email,
            "photoURL": photoPath
        ]
        firestore?.collection("users").document(idUser).setData(userData, completion: completion)
    }
    
    private func updateAuthProfile(user: FirebaseAuth.User?, name: String, photoReference: StorageReference?) {
        guard let user = user else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        guard let photoReference = photoReference else {
            changeRequest.commitChanges(completion: nil)
            return
        }
        
        photoReference.downloadURL { url, _ in
            if let url = url {
                changeRequest.photoURL = url
            }
            changeRequest.commitChanges(completion: nil)
        }
    }
    
    private func rollbackRegistration(user: FirebaseAuth.User?, storageReference: StorageReference? = nil) {
        storageReference?.delete(completion: nil)
        user?.delete(completion: nil)
    }
    
    private func presentImagePicker(for sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        registerScreen?.validateTextFields()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: RegisterScreenProtocol {
    
    func actionRegisterButton() {
        
        guard let register = registerScreen else { return }
        let name = register.getName()
        let email = register.getEmail()
        let password = register.getPassword()
        
        self.auth?.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.alert?.getAlert(title: "Atenção", message: "Erro ao cadastrar usuário, tente novamente!\n\(error.localizedDescription)")
                }
                return
            }
            
            guard let idUser = result?.user.uid else {
                DispatchQueue.main.async {
                    self.alert?.getAlert(title: "Atenção", message: RegisterError.userUnavailable.errorDescription ?? "")
                }
                return
            }
            
            self.uploadProfileImage(for: idUser) { uploadResult in
                switch uploadResult {
                case .success(let payload):
                    let (photoPath, storageReference) = payload
                    self.saveUserDocument(idUser: idUser, name: name, email: email, photoPath: photoPath) { error in
                        if let error = error {
                            DispatchQueue.main.async {
                                self.alert?.getAlert(title: "Atenção", message: "Erro ao salvar os dados do usuário.\n\(error.localizedDescription)")
                            }
                            self.rollbackRegistration(user: result?.user, storageReference: storageReference)
                            return
                        }
                        
                        self.updateAuthProfile(user: result?.user, name: name, photoReference: storageReference)
                        
                        DispatchQueue.main.async {
                            self.registerScreen?.cleanTextFields()
                            self.registerScreen?.resetProfileImage()
                            self.selectedProfileImage = nil
                            
                            self.alert?.getAlert(title: "Parabéns", message: "Usuário cadastrado com sucesso!") {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.alert?.getAlert(title: "Atenção", message: "Erro ao enviar a imagem de perfil.\n\(error.localizedDescription)")
                    }
                    self.rollbackRegistration(user: result?.user)
                }
            }
        }
        registerScreen?.validateTextFields()
    }
    
    func actionLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionTextDidChange() {
        registerScreen?.validateTextFields()
    }
    
    func actionAvatarTapped(from view: UIView) {
        let actionSheet = UIAlertController(title: "Foto do perfil", message: "Escolha uma opção", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Tirar foto", style: .default) { [weak self] _ in
                self?.presentImagePicker(for: .camera)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Escolher da galeria", style: .default) { [weak self] _ in
            self?.presentImagePicker(for: .photoLibrary)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }
        
        present(actionSheet, animated: true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let editedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        selectedProfileImage = editedImage
        registerScreen?.setProfileImage(editedImage)
    }
}
