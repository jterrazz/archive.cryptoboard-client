//
//  ListController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    private let COIN_LIST_CELL_ID: String = "coin-list-cell-id"
    private let GENERAL_COIN_CELL_ID: String = "general-coin-cell-id"
    
    override func viewDidLoad() {
        
        tableView.separatorStyle = .none

        tableView.register(CoinListCell.self, forCellReuseIdentifier: COIN_LIST_CELL_ID)
        tableView.register(UINib.init(nibName: "GeneralCoinListCell", bundle: Bundle.main), forCellReuseIdentifier: GENERAL_COIN_CELL_ID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.theme.bg.value
        
        let bar = navigationController?.navigationBar
        bar?.backgroundColor = UIColor.theme.bg.value
        bar?.barTintColor = UIColor.theme.bg.value
        bar?.tintColor = UIColor.white
        bar?.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.theme.textDark.value]
        bar?.topItem?.title = "Crypto currencies"
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = nil
    }
    
    
}

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: GENERAL_COIN_CELL_ID, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: COIN_LIST_CELL_ID, for: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DashboardController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
