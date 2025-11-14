//
//  OutgoingTextMessageTableViewCell.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 14/11/25.
//

import UIKit

class OutgoingTextMessageTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: OutgoingTextMessageTableViewCell.self)
    
    private lazy var outgoingTextMessageScreen: OutgoingTextMessageTableViewCellScreen = {
        let view = OutgoingTextMessageTableViewCellScreen()
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
        contentView.addSubview(outgoingTextMessageScreen)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            outgoingTextMessageScreen.topAnchor.constraint(equalTo: contentView.topAnchor),
            outgoingTextMessageScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outgoingTextMessageScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outgoingTextMessageScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func setupCell(message: Message) {
        outgoingTextMessageScreen.configMessage(message: message.text ?? "")
    }
}
