//
//  CoinDetailController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 25/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinDetailController: UITableViewController {
    
    let COIN_GRAPH_CELL_ID = "coin-graph-cell-id"
    let HEADER_CELL_ID = "header-cell-id"
    let COIN_INFOS_CELL_ID = "coin-infos-cell-id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.bounces = false
        tableView.register(CoinGraphCell.self, forCellReuseIdentifier: COIN_GRAPH_CELL_ID)
        tableView.register(CoinInfosCell.self, forCellReuseIdentifier: COIN_INFOS_CELL_ID)
        tableView.register(MenuHeaderCell.self, forHeaderFooterViewReuseIdentifier: HEADER_CELL_ID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}

extension CoinDetailController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_CELL_ID) as! MenuHeaderCell
        cell.setup(title: "Informations")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: COIN_GRAPH_CELL_ID, for: indexPath)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: COIN_INFOS_CELL_ID, for: indexPath) as! CoinInfosCell
            cell.setup(leftText: "Market Cap", rightText: "246")
            
            return cell
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 4
        }
    }
}
