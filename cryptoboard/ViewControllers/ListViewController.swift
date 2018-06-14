//
//  ListController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

// TODO Make language translations

class ListViewController: UIViewController {
    
    private let COIN_WITH_CHART_CELL_ID: String = "coin-with-chart-cell-id"
    private let GENERAL_COIN_CELL_ID: String = "general-coin-cell-id"
    private let COIN_WITH_CHART_HEADER_ID: String = "coin-with-chart-header-id"
    private let MENU_TITLE_CELL_ID: String = "menu-title-cell-id"
    private let NETWORK_ERROR_CELL_ID: String = "network-error-cell-id"
    private let EMPTY_CELL_ID: String = "empty-cell-id"
    
    lazy var tableView = UITableView()
    lazy var topBarBg = UIView() // Using this because of iphone X doing a bad UIImage()
    
    var networkError = false {
        didSet {
            self.tableView.reloadData()
            self.tableView.isScrollEnabled = !networkError
        }
    }
    var isLoading: Bool {
        get {
            return currencyList.count == 0
        }
    }
    var currencyList = [Currency]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        tableView.register(UINib.init(nibName: "GeneralCoinListCell", bundle: Bundle.main), forCellReuseIdentifier: GENERAL_COIN_CELL_ID)
        tableView.register(UINib.init(nibName: "CoinWithChartCell", bundle: Bundle.main), forCellReuseIdentifier: COIN_WITH_CHART_CELL_ID)
        tableView.register(CoinWithChartHeader.self, forHeaderFooterViewReuseIdentifier: COIN_WITH_CHART_HEADER_ID)
        tableView.register(MenuTitleCell.self, forCellReuseIdentifier: MENU_TITLE_CELL_ID)
        tableView.register(FollowCoinErrorCell.self, forCellReuseIdentifier: NETWORK_ERROR_CELL_ID)
        tableView.register(FollowCoinEmptyCell.self, forCellReuseIdentifier: EMPTY_CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        
        let bar = navigationController?.navigationBar
        bar?.backgroundColor = UIColor.theme.redDark.value
        bar?.barTintColor = UIColor.theme.redDark.value
        bar?.topItem?.title = "Hot coins"
        bar?.tintColor = UIColor.white
        topBarBg.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        self.networkError = false
        
        CurrencyController().getList(limit: 100) { (error, currencies) in
            DispatchQueue.main.async {
                if (error != nil) {
                    self.currencyList.removeAll()
                    self.networkError = true
                    return
                }
                self.currencyList = currencies
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    // Add global variable for constraints wave
    private func setupViews() {
        view.backgroundColor = UIColor.theme.grayBg.value
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        topBarBg.backgroundColor = UIColor.theme.redDark.value
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubviewsAutoConstraints([tableView, topBarBg])
        
        let views = [
            "table": tableView,
            "topBarBg": topBarBg
        ]
        let constraints = [
            "H:|[table]|",
            "V:[table]|",
            "H:|[topBarBg]|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarBg.topAnchor.constraint(equalTo: view.topAnchor),
            topBarBg.bottomAnchor.constraint(equalTo: view.safeTopAnchor)
            ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (networkError || isLoading) {
            return 1
        }
        switch section {
        case 0:
            return 2
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
            if (indexPath.row == 0) {
                let dataCell = tableView.dequeueReusableCell(withIdentifier: MENU_TITLE_CELL_ID, for: indexPath) as! MenuTitleCell
                
                dataCell.setup(title: "Hot coins")
                cell = dataCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: GENERAL_COIN_CELL_ID, for: indexPath)
            }
        default:
            if (networkError) {
                let cell = tableView.dequeueReusableCell(withIdentifier: NETWORK_ERROR_CELL_ID, for: indexPath) as! FollowCoinErrorCell
                
                cell.contentView.backgroundColor = UIColor.theme.grayBg.value
                return cell
            } else if (isLoading) {
                let cell = tableView.dequeueReusableCell(withIdentifier: EMPTY_CELL_ID, for: indexPath)
                
                cell.contentView.backgroundColor = UIColor.theme.grayBg.value
                return cell
            }
            
            let dataCell = tableView.dequeueReusableCell(withIdentifier: COIN_WITH_CHART_CELL_ID, for: indexPath) as! CoinWithChartCell
            
            dataCell.setup(currency: currencyList[indexPath.row])
            cell = dataCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (networkError) {
            loadData()
        } else if (isLoading) {
            return
        } else if (indexPath.section == 1) {
            let currency = currencyList[indexPath.row]
            let vc = CoinDetailController(currency: currency)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return UITableViewAutomaticDimension
        }
        if (networkError || isLoading) {
            return tableView.frame.height - 100
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (networkError || isLoading) {
            return 0
        }
        if (section == 1) {
            return 36
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isLoading) {
            let scrolledDistance = scrollView.contentOffset.y
            let trigger: CGFloat = -12
            
            if (scrolledDistance > trigger) {
                navigationController?.setNavigationBarHidden(false, animated: true)
                topBarBg.alpha = 1
            } else {
                navigationController?.setNavigationBarHidden(true, animated: true)
                topBarBg.alpha = 0
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        tableView.reloadData()
    }
    
    
}
