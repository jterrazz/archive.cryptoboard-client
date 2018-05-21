//
//  SettingsController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        
        let views: [String: Any] = [
            "tableView": tableView,
        ]
        let constraints = [
            "H:|[tableView]|",
            "V:|[tableView]|"
        ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    

}
