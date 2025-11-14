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
    
    
    override func loadView() {
        chatScreen = ChatScreen()
        self.view = chatScreen
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
