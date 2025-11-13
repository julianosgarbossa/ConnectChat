//
//  NavScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

enum TypeAction {
    case conversations
    case contacts
    case search
}

protocol NavScreenProtocol: AnyObject {
    func typeAction(type: TypeAction)
}

class NavScreen: UIView {
    
    private weak var delegate: NavScreenProtocol?
    
    private lazy var navBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 0.02).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var navBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var searchBar: UIView = {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Digite aqui"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    lazy var conversationsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemTeal
        button.addTarget(self, action: #selector(tappedConversationsButton), for: .touchUpInside)
        return button
    }()
    
    lazy var contactsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedContactsButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func tappedSearchButton(_ sender: UIButton) {
        self.delegate?.typeAction(type: .search)
    }
    
    @objc private func tappedConversationsButton(_ sender: UIButton) {
        conversationsButton.tintColor = .systemTeal
        contactsButton.tintColor = .white
        self.delegate?.typeAction(type: .conversations)
    }
    
    @objc private func tappedContactsButton(_ sender: UIButton) {
        contactsButton.tintColor = .systemTeal
        conversationsButton.tintColor = .white
        self.delegate?.typeAction(type: .contacts)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        addSubview(navBackgroundView)
        navBackgroundView.addSubview(navBar)
        navBar.addSubview(searchBar)
        navBar.addSubview(stackView)
        searchBar.addSubview(searchLabel)
        searchBar.addSubview(searchButton)
        stackView.addArrangedSubview(conversationsButton)
        stackView.addArrangedSubview(contactsButton)

        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // navBackgroundView ocupa toda a área da view
            navBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            navBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // navBar ocupa quase toda a area, menos no topo que começa da safeArea
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // searchBar centralizada na navBar e com traling da stackView
            searchBar.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 30),
            searchBar.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
            
            // searchLabel dentro da searchBar
            searchLabel.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 25),
            
            // searchButton dentro da searchBar
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            
            // stackView ao lado da searchBar
            stackView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    public func delegate(delegate: NavScreenProtocol?) {
        self.delegate = delegate
    }
}
