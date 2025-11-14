//
//  ChatScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

protocol ChatScreenProtocol: AnyObject {
    func actionSendButton()
}

class ChatScreen: UIView {
    
    private weak var delegate: ChatScreenProtocol?

    private var bottomContraint: NSLayoutConstraint?
    
    private lazy var chatNavScreen: ChatNavScreen = {
        let view = ChatNavScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.register(OutgoingTextMessageTableViewCell.self, forCellReuseIdentifier: OutgoingTextMessageTableViewCell.identifier)
        tableView.register(IncomingTextMessageTableViewCell.self, forCellReuseIdentifier: IncomingTextMessageTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var messageInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        return view
    }()
    
    private lazy var messageBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var inputMessageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Digite aqui", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        textField.textColor = .white
        textField.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 22.5
        button.layer.shadowColor = UIColor.systemTeal.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.3
        button.isEnabled = false
        button.layer.opacity = 0.4
        button.transform = .init(scaleX: 0.8, y: 0.8)
        button.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func tappedSendButton(_ sender: UIButton) {
        self.delegate?.actionSendButton()
    }
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomContraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { completed in
                
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bottomContraint = messageInputView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomContraint?.isActive = true
        
        self.inputMessageTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        backgroundColor =  UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        
        addSubview(chatNavScreen)
        addSubview(tableView)
        addSubview(messageInputView)
        messageInputView.addSubview(messageBar)
        messageBar.addSubview(inputMessageTextField)
        messageBar.addSubview(sendButton)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            chatNavScreen.topAnchor.constraint(equalTo: topAnchor),
            chatNavScreen.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatNavScreen.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatNavScreen.heightAnchor.constraint(equalToConstant: 140),
            
            tableView.topAnchor.constraint(equalTo: chatNavScreen.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            messageInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 100),
            
            messageBar.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            messageBar.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 30),
            messageBar.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -30),
            messageBar.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.centerYAnchor.constraint(equalTo: messageBar.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: messageBar.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            
            inputMessageTextField.centerYAnchor.constraint(equalTo: messageBar.centerYAnchor),
            inputMessageTextField.leadingAnchor.constraint(equalTo: messageBar.leadingAnchor),
            inputMessageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -20),
            inputMessageTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    public func delegate(delegate: ChatScreenProtocol?) {
        self.delegate = delegate
    }
    
    public func chatNavScreenDelegate(delegate: ChatNavScreenProtocol?) {
        chatNavScreen.delegate(delegate: delegate)
    }
    
    public func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    public func getInputMessageText() -> String {
        return inputMessageTextField.text ?? ""
    }
    
    public func clearInputMessage() {
        inputMessageTextField.text = ""
        sendButton.isEnabled = false
        sendButton.layer.opacity = 0.4
    }
}

extension ChatScreen: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if inputMessageTextField.text == "" {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.sendButton.isEnabled = false
                self.sendButton.layer.opacity = 0.4
            }, completion: { _ in
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.sendButton.isEnabled = true
                self.sendButton.layer.opacity = 1.0
            }, completion: { _ in
            })
        }
    }
}
