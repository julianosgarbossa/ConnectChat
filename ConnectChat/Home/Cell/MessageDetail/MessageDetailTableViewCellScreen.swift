//
//  MessageDetailTableViewCellScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

class MessageDetailTableViewCellScreen: UIView {
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.image = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        return image
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nome do Usuário"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        addSubview(profileImageView)
        addSubview(userName)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            
            userName.centerYAnchor.constraint(equalTo: centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
        ])
    }
    
    private func setUserName(userName: String) {
        let attributedText = NSMutableAttributedString(string: userName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        
        self.userName.attributedText = attributedText
    }
    
    private func setUserNameAttributedText(conversation: Conversation) {
        let attributedText = NSMutableAttributedString(string: "\(conversation.name ?? "")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)])
        
        attributedText.append(NSAttributedString(string: "\n\(conversation.lastMessage ?? "")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]))
        
        userName.attributedText = attributedText
    }
    
    public func configContact(contact: Contact) {
        setUserName(userName: contact.name ?? "")
    }
    
    public func configConversation(conversation: Conversation) {
        setUserNameAttributedText(conversation: conversation)
    }
}
