//
//  RegisterScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 11/11/25.
//

import UIKit

protocol RegisterScreenProtocol: AnyObject {
    func actionRegisterButton()
    func actionLoginButton()
}

class RegisterScreen: UIView {
    
    private weak var delegate: RegisterScreenProtocol?

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cadastro"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Crie sua conta com segurança"
        label.textColor = UIColor(white: 1.0, alpha: 0.7)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string: "Nome", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        textfield.textColor = .white
        textfield.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        textfield.layer.cornerRadius = 8
        textfield.autocapitalizationType = .none
        return textfield
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
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cadastrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSMutableAttributedString(string: "Já possui conta? ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "Entre", attributes: [.foregroundColor: UIColor.systemTeal,.font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func tappedRegisterButton(_ sender: UIButton) {
        self.delegate?.actionRegisterButton()
    }
    
    @objc private func tappedLoginButton(_ sender: UIButton) {
        self.delegate?.actionLoginButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElemnets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientToButton()
    }
    
    private func setVisualElemnets() {
        backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        setupLeftIcon(for: nameTextField, systemName: "person")
        setupLeftIcon(for: emailTextField, systemName: "envelope")
        setupLeftIcon(for: passwordTextField, systemName: "lock")
        
        addSubview(photoImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(loginButton)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            // photoImageView acima do titleLabel
            photoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 150),
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            // titleLabel acima do subTitleLabel
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -4),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // subTitleLabel acima do nameTextField
            subTitleLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -40),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // centraliza o nameTextField no meio da tela
            nameTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // emailTextField abaixo do nameTextField
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            // passwordTextField abaixo do emailTextField
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            // registerButton abaixo do passwordTextField
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            
            // loginButton abaixo do forgotPasswordButton
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func applyGradientToButton() {
        guard registerButton.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil else { return }

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0/255, green: 204/255, blue: 153/255, alpha: 1).cgColor,
            UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = registerButton.bounds
        gradient.cornerRadius = 12
        registerButton.layer.insertSublayer(gradient, at: 0)
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
        nameTextField.delegate = delegate
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }
    
    public func delegate(delegate: RegisterScreenProtocol?){
        self.delegate = delegate
    }
    
}
