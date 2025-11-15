//
//  OutgoingTextMessageTableViewCellScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 14/11/25.
//

import UIKit

class OutgoingTextMessageTableViewCellScreen: UIView {

    private lazy var myMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var senderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .right
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
        addSubview(myMessageView)
        myMessageView.addSubview(messageTextLabel)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            senderNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            senderNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            myMessageView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 6),
            myMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            myMessageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            myMessageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            senderNameLabel.trailingAnchor.constraint(equalTo: myMessageView.trailingAnchor),
            
            messageTextLabel.topAnchor.constraint(equalTo: myMessageView.topAnchor, constant: 12),
            messageTextLabel.leadingAnchor.constraint(equalTo: myMessageView.leadingAnchor, constant: 15),
            messageTextLabel.trailingAnchor.constraint(equalTo: myMessageView.trailingAnchor, constant: -15),
            messageTextLabel.bottomAnchor.constraint(equalTo: myMessageView.bottomAnchor, constant: -12),
        ])
    }
    
    public func configMessage(message: String?, senderName: String) {
        senderNameLabel.text = senderName
        messageTextLabel.text = message ?? ""
    }
}
