//
//  ChatViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit
import FirebaseFirestore

class ChatViewController: UIViewController {

    private var chatScreen: ChatScreen?
    private var alert: Alert?
    
    override func loadView() {
        chatScreen = ChatScreen()
        self.view = chatScreen
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = Alert(controller: self)
        self.setProtocols()

    }
    
    private func setProtocols() {
        chatScreen?.chatNavScreenDelegate(delegate: self)
    }
}

extension ChatViewController: ChatNavScreenProtocol {
    func actionBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionSearchButton() {
        alert?.getAlert(title: "Atenção", message: "A funcionalidade de pesquis ainda não foi implementada, tente novamente mais tarde!")
    }
}
