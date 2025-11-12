//
//  LoginViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 10/11/25.
//

import UIKit

class LoginViewController: UIViewController {

    private var loginScreen: LoginScreen?
    
    override func loadView() {
        loginScreen = LoginScreen()
        self.view = loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
     
    }
    
    private func setDelegates() {
        loginScreen?.configTextFieldDelegate(delegate: self)
        loginScreen?.delegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loginScreen?.validateTextFields()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loginScreen?.validateTextFields()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginViewController: LoginScreenProtocol {
   
    func actionLoginButton() {
        print("Login Efetuado Com Sucesso!")
        loginScreen?.cleanTextFields()
        loginScreen?.validateTextFields()
    }
    
    func actionForgotPasswordButton() {
        print("A Funcionalidade Recuperar Senha Será Implementada Em Breve!")
    }
    
    func actionRegisterButton() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func actionTextDidChange() {
        loginScreen?.validateTextFields()
    }
}

