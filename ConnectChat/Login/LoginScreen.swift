//
//  LoginScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 11/11/25.
//

import UIKit

protocol LoginScreenProtocol: AnyObject {
    func actionLoginButton()
    func actionForgotPasswordButton()
    func actionRegisterButton()
}

class LoginScreen: UIView {
    
    private weak var delegate: LoginScreenProtocol?

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Conecte-se com segurança"
        label.textColor = UIColor(white: 1.0, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
        
    private lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        textfield.textColor = .white
        textfield.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        textfield.layer.cornerRadius = 8
        textfield.autocapitalizationType = .none
        textfield.keyboardType = .emailAddress
        return textfield
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Entrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Esqueceu a senha?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.addTarget(self, action: #selector(tappedForgotPasswordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSMutableAttributedString(string: "Não tem conta? ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "Cadastre-se", attributes: [.foregroundColor: UIColor.systemTeal,.font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func tappedLoginButton(_ sender: UIButton) {
        self.delegate?.actionLoginButton()
    }
    
    @objc private func tappedForgotPasswordButton(_ sender: UIButton) {
        self.delegate?.actionForgotPasswordButton()
    }
    
    @objc private func tappedRegisterButton(_ sender: UIButton) {
        self.delegate?.actionRegisterButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientToButton()
    }
    
    private func setVisualElements() {
        backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        setupLeftIcon(for: emailTextField, systemName: "envelope")
        setupLeftIcon(for: passwordTextField, systemName: "lock")
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(forgotPasswordButton)
        addSubview(registerButton)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            // logoImageView acima do titleLabel
            logoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            // titleLabel acima do subTitleLabel
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -4),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // subTitleLabel acima do emailTextField
            subTitleLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -40),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // centraliza o emailTextField no meio da tela
            emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // passwordTextField abaixo do emailTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            // loginButton abaixo do passwordTextField
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            // forgotPasswordButton abaixo do loginButton
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            // registerButton abaixo do forgotPasswordButton
            registerButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func applyGradientToButton() {
        guard loginButton.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil else { return }

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0/255, green: 204/255, blue: 153/255, alpha: 1).cgColor,
            UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = loginButton.bounds
        gradient.cornerRadius = 12
        loginButton.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupLeftIcon(for textField: UITextField, systemName: String) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = UIColor.white.withAlphaComponent(0.7)
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 14, y: 0, width: 22, height: 22)
        icon.center.y = containerView.center.y
        containerView.addSubview(icon)
        textField.leftView = containerView
        textField.leftViewMode = .always
    }
    
    public func configTextFieldDelegate(delegate: UITextFieldDelegate) {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
    
    public func delegate(delegate: LoginScreenProtocol?) {
        self.delegate = delegate
    }
}
