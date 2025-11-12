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
        print("Usuário Registrado Com Sucesso!")
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
