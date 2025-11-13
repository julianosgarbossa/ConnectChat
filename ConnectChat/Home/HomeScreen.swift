//
//  HomeScreen.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import UIKit

class HomeScreen: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVisualElements() {
        backgroundColor = UIColor(red: 11/255, green: 60/255, blue: 73/255, alpha: 1.0)
        
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([

        ])
    }
}
