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
        view.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        return view
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
        addSubview(contactMessageView)
        contactMessageView.addSubview(messageTextLabel)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contactMessageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contactMessageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contactMessageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            self.messageTextLabel.topAnchor.constraint(equalTo: contactMessageView.topAnchor, constant: 15),
            self.messageTextLabel.leadingAnchor.constraint(equalTo: contactMessageView.leadingAnchor, constant: 15),
            self.messageTextLabel.trailingAnchor.constraint(equalTo: contactMessageView.trailingAnchor, constant: -15),
            self.messageTextLabel.bottomAnchor.constraint(equalTo: contactMessageView.bottomAnchor, constant: -15),
        ])
    }
    
    public func configMessage(message: String?) {
        messageTextLabel.text = message ?? ""
    }
}
