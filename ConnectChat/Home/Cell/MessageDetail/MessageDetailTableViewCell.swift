//
//  MessageDetailTableViewCell.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

class MessageDetailTableViewCell: UITableViewCell {

    static let identifier: String = String(describing: MessageDetailTableViewCell.self)
    
    private lazy var messageDetailScreen: MessageDetailTableViewCellScreen = {
        let view = MessageDetailTableViewCellScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        contentView.addSubview(messageDetailScreen)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            messageDetailScreen.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageDetailScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageDetailScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messageDetailScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func setupMessageDetailTableViewCell(contact: Contact) {
        messageDetailScreen.configContact(contact: contact)
    }
    
    public func setupMessageDetailTableViewCell(conversation: Conversation) {
        messageDetailScreen.configConversation(conversation: conversation)
    }
}
