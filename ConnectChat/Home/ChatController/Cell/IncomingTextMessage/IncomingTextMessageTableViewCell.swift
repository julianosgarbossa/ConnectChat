//
//  IncomingTextMessageTableViewCell.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 14/11/25.
//

import UIKit

class IncomingTextMessageTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: IncomingTextMessageTableViewCell.self)

    private lazy var incomingTextMessageScreen: IncomingTextMessageTableViewCellScreen = {
        let view = IncomingTextMessageTableViewCellScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        self.isSelected = false
        
        contentView.addSubview(incomingTextMessageScreen)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            incomingTextMessageScreen.topAnchor.constraint(equalTo: contentView.topAnchor),
            incomingTextMessageScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            incomingTextMessageScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            incomingTextMessageScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func setupCell(message: Message, senderDisplayName: String) {
        incomingTextMessageScreen.configMessage(message: message.displayText, senderName: senderDisplayName)
    }
}
