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
    }
}

extension LoginViewController: UITextFieldDelegate {

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

extension LoginViewController: LoginScreenProtocol {
   
    func actionLoginButton() {
        print("Login Efetuado Com Sucesso!")
    }
    
    func actionForgotPasswordButton() {
        print("A Funcionalidade Recuperar Senha Será Implementada Em Breve!")
    }
    
    func actionRegisterButton() {
        navigationItem.backButtonTitle = "Login"
        navigationController?.navigationBar.tintColor = UIColor.white.withAlphaComponent(0.7)
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}

