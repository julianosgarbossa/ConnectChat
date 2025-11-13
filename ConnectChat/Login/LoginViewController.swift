//
//  LoginViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 10/11/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private var loginScreen: LoginScreen?
    private var auth: Auth?
    private var alert: Alert?
    
    override func loadView() {
        loginScreen = LoginScreen()
        self.view = loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.auth = Auth.auth()
        self.alert = Alert(controller: self)
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
        guard let login = loginScreen else { return }
        
        auth?.signIn(withEmail: login.getEmail(), password: login.getPassword()) { result, error in
            if error == nil {
                
                if result != nil {
                    self.loginScreen?.cleanTextFields()
                    let homeViewController = HomeViewController()
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                } else {
                    self.alert?.getAlert(title: "Atenção", message: "Tivemos um problema inesperado, tente novamente mais tarde!")
                }
            } else {
                self.alert?.getAlert(title: "Atenção", message: "Email ou senha incorreto, tente novamente!")
            }
        }
        loginScreen?.validateTextFields()
    }
    
    func actionForgotPasswordButton() {
        alert?.getAlert(title: "Atenção", message: "A funcionalidade recuperar senha ainda não foi implementada, tente novamente mais tarde!")
    }
    
    func actionRegisterButton() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func actionTextDidChange() {
        loginScreen?.validateTextFields()
    }
}

