//
//  IncomingTextMessageTableViewCellScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 14/11/25.
//

import UIKit

class IncomingTextMessageTableViewCellScreen: UIView {

    
    private lazy var contactMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private lazy var senderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        addSubview(senderNameLabel)
        addSubview(contactMessageView)
        contactMessageView.addSubview(messageTextLabel)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            senderNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            contactMessageView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 6),
            contactMessageView.leadingAnchor.constraint(equalTo: senderNameLabel.leadingAnchor),
            contactMessageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            contactMessageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            senderNameLabel.trailingAnchor.constraint(equalTo: contactMessageView.trailingAnchor),
            
            messageTextLabel.topAnchor.constraint(equalTo: contactMessageView.topAnchor, constant: 12),
            messageTextLabel.leadingAnchor.constraint(equalTo: contactMessageView.leadingAnchor, constant: 15),
            messageTextLabel.trailingAnchor.constraint(equalTo: contactMessageView.trailingAnchor, constant: -15),
            messageTextLabel.bottomAnchor.constraint(equalTo: contactMessageView.bottomAnchor, constant: -12),
        ])
    }
    
    public func configMessage(message: String?, senderName: String) {
        senderNameLabel.text = senderName
        messageTextLabel.text = message ?? ""
    }
}
