//
//  HomeViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    private var homeScreen: HomeScreen?
    private var alert: Alert?
    private var auth: Auth?

    override func loadView() {
        homeScreen = HomeScreen()
        self.view = homeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert = Alert(controller: self)
        self.setProtocols()
    }
    
    private func setProtocols() {
        homeScreen?.configNavScreenProtocol(delegate: self)
        homeScreen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension HomeViewController: NavScreenProtocol {
    func typeAction(type: TypeAction) {
        switch type {
        case .search:
            alert?.getAlert(title: "Atenção", message: "A funcionalidade de pesquisar ainda não foi implementada, tente novamente mais tarde!")
        case .conversations:
            alert?.getAlert(title: "Temporário", message: "Navegar para tela de conversas")
        case .contacts:
            alert?.getAlert(title: "Temporário", message: "Navegar para tela de contatos")
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}




