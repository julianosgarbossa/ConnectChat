//
//  MessageLastTableViewCell.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

class MessageLastTableViewCell: UITableViewCell {

    static let identifier: String = String(describing: MessageLastTableViewCell.self)
    
    private lazy var messageLastScreen: MessageLastTableViewCellScreen = {
        let view = MessageLastTableViewCellScreen()
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
        self.selectionStyle = .none
        
        contentView.addSubview(messageLastScreen)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            messageLastScreen.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLastScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageLastScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messageLastScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
