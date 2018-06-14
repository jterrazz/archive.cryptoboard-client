//
//  ListController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    private let COIN_WITH_CHART_CELL_ID: String = "coin-with-chart-cell-id"
    private let GENERAL_COIN_CELL_ID: String = "general-coin-cell-id"
    private let COIN_WITH_CHART_HEADER_ID: String = "coin-with-chart-header-id"
    
    lazy var tableView = UITableView()
    
    var currencyList = [Currency]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.register(UINib.init(nibName: "GeneralCoinListCell", bundle: Bundle.main), forCellReuseIdentifier: GENERAL_COIN_CELL_ID)
        tableView.register(UINib.init(nibName: "CoinWithChartCell", bundle: Bundle.main), forCellReuseIdentifier: COIN_WITH_CHART_CELL_ID)
        tableView.register(CoinWithChartHeader.self, forHeaderFooterViewReuseIdentifier: COIN_WITH_CHART_HEADER_ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        let bar = navigationController?.navigationBar
        bar?.tintColor = UIColor.white
        bar?.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        bar?.topItem?.title = "Hot coins"
        bar?.barStyle = .black
        
        DispatchQueue.main.async {
            CurrencyController.getList(limit: 50) { (error, currencies) in
                // TODO If error print message to reload
                self.currencyList = currencies
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupViews() {
        view.setGradient(colors: UIColor.gradients.darkPurple.cgColors, angle: 65)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubviewsAutoConstraints([tableView])
        
        let views = [
            "table": tableView
        ]
        let constraints = [
            "H:|[table]|",
            "V:[table]|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeTopAnchor)
            ])
    }
    
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return currencyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: COIN_WITH_CHART_HEADER_ID)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: GENERAL_COIN_CELL_ID, for: indexPath)
        default:
            let dataCell = tableView.dequeueReusableCell(withIdentifier: COIN_WITH_CHART_CELL_ID, for: indexPath) as! CoinWithChartCell
            
            dataCell.setup(currency: currencyList[indexPath.row])
            cell = dataCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let currency = currencyList[indexPath.row]
            let vc = CoinDetailController(currency: currency)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 36
        }
        return 0
    }
    
    
}
