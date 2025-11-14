//
//  ChatNavScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit

protocol ChatNavScreenProtocol: AnyObject {
    func actionBackButton()
    func actionSearchButton()
}

class ChatNavScreen: UIView {

    private weak var delegate: ChatNavScreenProtocol?
    
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.image = UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
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
    
    @objc private func tappedBackButton(_ sender: UIButton) {
        self.delegate?.actionBackButton()
    }
    
    @objc private func tappedSearchButton(_ sender: UIButton) {
        self.delegate?.actionSearchButton()
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
        navBar.addSubview(backButton)
        navBar.addSubview(imageProfile)
        navBar.addSubview(searchBar)
        searchBar.addSubview(searchLabel)
        searchBar.addSubview(searchButton)
        
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
            
            // backButton está dentro da navBar e a esquerda dela
            backButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            // backButton está dentro da navBar e no centro dela
            imageProfile.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            imageProfile.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            imageProfile.heightAnchor.constraint(equalToConstant: 55),
            imageProfile.widthAnchor.constraint(equalToConstant: 55),
            
            // searchBar está dentro da navBar e do lado direito dela
            searchBar.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: imageProfile.trailingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
            
            // searchLabel dentro da searchBar lado esquerdo
            searchLabel.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 25),
            
            // searchButton dentro da searchBar lado direito
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    public func delegate(delegate: ChatNavScreenProtocol?) {
        self.delegate = delegate
    }

}
