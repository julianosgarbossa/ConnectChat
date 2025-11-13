//
//  HomeScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import UIKit

class HomeScreen: UIView {
    
    private lazy var navScreen: NavScreen = {
        let screen = NavScreen()
        screen.translatesAutoresizingMaskIntoConstraints = false
        return screen
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delaysContentTouches = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        backgroundColor = UIColor(red: 6/255, green: 46/255, blue: 56/255, alpha: 1.0)
        
        addSubview(navScreen)
        addSubview(tableView)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            navScreen.topAnchor.constraint(equalTo: topAnchor),
            navScreen.leadingAnchor.constraint(equalTo: leadingAnchor),
            navScreen.trailingAnchor.constraint(equalTo: trailingAnchor),
            navScreen.heightAnchor.constraint(equalToConstant: 140),
            
            tableView.topAnchor.constraint(equalTo: navScreen.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configNavScreenProtocol(delegate: NavScreenProtocol) {
        navScreen.delegate(delegate: delegate)
    }
    
    public func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    public func realoadTableView() {
        tableView.reloadData()
    }
}
