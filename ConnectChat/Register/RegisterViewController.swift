//
//  RegisterViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 11/11/25.
//

import UIKit

class RegisterViewController: UIViewController {

    private var registerScreen: RegisterScreen?
    
    override func loadView() {
        registerScreen = RegisterScreen()
        self.view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    private func setDelegates() {
        registerScreen?.configTextFieldDelegate(delegate: self)
        registerScreen?.delegate(delegate: self)
    }
}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: RegisterScreenProtocol {
    func actionRegisterButton() {
        print("Usuário Registrado Com Sucesso!")
    }
    
    func actionLoginButton() {
        navigationController?.popViewController(animated: true)
    }
}
