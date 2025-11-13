//
//  HomeViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    private var homeScreen: HomeScreen?
    
    override func loadView() {
        homeScreen = HomeScreen()
        self.view = homeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}




