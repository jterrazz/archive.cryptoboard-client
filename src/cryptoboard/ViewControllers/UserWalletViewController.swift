//
//  WalletViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class UserWalletViewController: UIViewController {
    
    lazy var headerView = UserWalletHeaderView()
    lazy var chartView = UserWalletChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.theme.bg.value
        
        view.addSubviewsAutoConstraints([headerView, chartView])
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            chartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            chartView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
