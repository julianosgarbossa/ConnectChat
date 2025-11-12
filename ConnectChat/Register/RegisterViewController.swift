//
//  RegisterViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 11/11/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    private var registerScreen: RegisterScreen?
    
    private var auth: Auth?
    
    override func loadView() {
        registerScreen = RegisterScreen()
        self.view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.auth = Auth.auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerScreen?.validateTextFields()
    }
    
    private func setDelegates() {
        registerScreen?.configTextFieldDelegate(delegate: self)
        registerScreen?.delegate(delegate: self)
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
        
        self.auth?.createUser(withEmail: register.getEmail(), password: register.getPassword()) { result, error in
            if error == nil {
                print("Usuário cadastrado com sucesso!")
            } else {
                print("Erro ao cadastrar usuário!")
            }
        }
        registerScreen?.cleanTextFields()
        registerScreen?.validateTextFields()
    }
    
    func actionLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionTextDidChange() {
        registerScreen?.validateTextFields()
    }
}
