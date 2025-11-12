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
    private var alert: Alert?
    
    override func loadView() {
        registerScreen = RegisterScreen()
        self.view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.auth = Auth.auth()
        self.alert = Alert(controller: self)
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
                self.registerScreen?.cleanTextFields()
                self.alert?.getAlert(title: "Parabens", message: "Usuário cadastrado com sucesso!") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.alert?.getAlert(title: "Atenção", message: "Erro ao cadastrar usuário, tente novamente!")
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
}
