//
//  CoinDetailController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 25/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

// TODO Remove all public
// check if didSet can be used
// TODO Set all labels to 0

class CoinDetailController: UIViewController {
    
    private let COIN_DETAIL_CHART_CELL_ID = "coin-detail-chart-cell-id"
    private let COIN_DETAIL_HEADER_ID = "coin-detail-header-id"
    private let COIN_INFORMATIONS_CELL_ID = "coin-informations-cell-id"
    private let NETWORK_ERROR_CELL_ID = "network-error-cell-id"
    
    lazy var tableView = UITableView()
    lazy var topBarBg = UIView() // Using this because of iphone X doing a bad UIImage()
    
    var currentTheme: ThemeStatus = .white
    var tapGesture: UITapGestureRecognizer!
    var currency: Currency?
    var networkError = false {
        didSet {
            tableView.reloadData()
            tableView.isScrollEnabled = !networkError
        }
    }
    
    convenience init(currency: Currency) {
        self.init()
        
        self.currency = currency
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CoinDetailChartCell.self, forCellReuseIdentifier: COIN_DETAIL_CHART_CELL_ID)
        tableView.register(CoinDetailTitleHeader.self, forHeaderFooterViewReuseIdentifier: COIN_DETAIL_HEADER_ID)
        tableView.register(CoinDetailInformationsCell.self, forCellReuseIdentifier: COIN_INFORMATIONS_CELL_ID)
        tableView.register(FollowCoinErrorCell.self, forCellReuseIdentifier: NETWORK_ERROR_CELL_ID)
        
        setupViews()
        
        let bar = navigationController?.navigationBar
        
        bar?.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.theme.darkBg.value
        setTheme(.clear)
        
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func setup(currency: Currency) {
        self.currency = currency
    }
    
    private func setupViews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        topBarBg.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.theme.bg.value
        
        navigationController?.navigationBar.barTintColor = UIColor.theme.darkBg.value
        navigationController?.navigationBar.backgroundColor = UIColor.theme.darkBg.value
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubviewsAutoConstraints([tableView, topBarBg])
        
        let views = [
            "scroll": tableView,
            "barBg": topBarBg
        ]
        let constraints = [
            "H:|[scroll]|",
            "V:[scroll]|",
            "H:|[barBg]|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            topBarBg.topAnchor.constraint(equalTo: view.topAnchor),
            topBarBg.bottomAnchor.constraint(equalTo: view.safeTopAnchor)
            ])
    }
    
    
}

extension CoinDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 15
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: COIN_DETAIL_HEADER_ID) as! CoinDetailTitleHeader
        switch section {
        case 1:
            view.setup(title: "Market data")
        default:
            view.setup(title: "Coin informations")
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If Error
        if (networkError) {
            let cell = tableView.dequeueReusableCell(withIdentifier: NETWORK_ERROR_CELL_ID, for: indexPath)
            
            return cell
        } else {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: COIN_DETAIL_CHART_CELL_ID, for: indexPath) as! CoinDetailChartCell
                cell.currency = currency
                cell.delegate = self
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: COIN_INFORMATIONS_CELL_ID, for: indexPath) as! CoinDetailInformationsCell
                var corners: UIRectCorner?
                
                if (indexPath.row == 0) {
                    corners = [.topLeft, .topRight]
                } else if (indexPath.row == 1) {
                    corners = [.bottomRight, .bottomLeft]
                }
                cell.setup(leftText: "Market cap", subLeftText: nil, rightText: "20,420,420,420", subRightText: nil, corners: corners)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return tableView.bounds.height
        }
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledDistance = scrollView.contentOffset.y
        let trigger = UIScreen.main.bounds.height / 6
        
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? CoinDetailChartCell {
            cell.setOffset(offset: scrolledDistance, trigger: trigger)
        }
        
        if (scrolledDistance > tableView.frame.height) {
            setTheme(.darkBlue)
        } else if (scrolledDistance > trigger) {
            setTheme(.white)
        } else {
            setTheme(.clear)
        }
    }
    
    private func setTheme(_ status: ThemeStatus) {
        let bar = self.navigationController?.navigationBar
        
        UIView.animate(withDuration: K.Design.AnimationTime) {
            if (status == .clear && self.currentTheme != .clear) {
                bar?.tintColor = UIColor.white
                self.topBarBg.backgroundColor = UIColor.clear
                bar?.barStyle = .black
                self.title = ""
            } else if (status == .white && self.currentTheme != .white) {
                bar?.tintColor = UIColor.theme.textDark.value
                self.topBarBg.backgroundColor = UIColor.white
                bar?.barStyle = .default
                self.title = ""
            } else if (status == .darkBlue && self.currentTheme != .darkBlue) {
                bar?.tintColor = UIColor.white
                self.topBarBg.backgroundColor = UIColor.theme.blue.value
                bar?.barStyle = .black
                self.title = self.currency?.name
            }
        }
        
        currentTheme = status
    }
    
    
}

extension CoinDetailController: CoinDetailChartCellDelegate {
    
    func didAskToChangePosition(side: VerticalPosition) {
        let indexPath = side == .up ? IndexPath(row: 0, section: 0) : IndexPath(row: 0, section: 1)
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
}
