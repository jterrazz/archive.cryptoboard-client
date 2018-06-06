//
//  CoinDetailController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 25/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinDetailController: UIViewController {
    
//    private let COIN_DETAIL_CHART_CELL_ID = "coin-detail-chart-cell-id"
    
    lazy var tableView = UITableView()
    lazy var chartView = CoinDetailChartView()
    lazy var topBarBg = UIView() // Using this because of iphone X doing a bad UIImage()
    
    var chartBottomConstraint: NSLayoutConstraint?
    var chartFullWidthConstraint: NSLayoutConstraint?
    var chartMarginWidthConstraint: NSLayoutConstraint?
    var currentTheme: ThemeStatus = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        setTheme(.clear)
        
        view.layoutIfNeeded()
    }
    
    private func setupViews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets.init(top: UIScreen.main.bounds.height, left: 0, bottom: 0, right: 0)
        
        topBarBg.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.theme.bg.value
        view.addSubviewsAutoConstraints([chartView, tableView, topBarBg])
        
        let chartTopConstraint = chartView.topAnchor.constraint(equalTo: tableView.topAnchor)
        let chartHeightConstraint = chartView.heightAnchor.constraint(greaterThanOrEqualTo: tableView.heightAnchor, multiplier: 0.7)
        chartTopConstraint.priority = UILayoutPriority(250)
        chartHeightConstraint.priority = UILayoutPriority(1000)
        chartBottomConstraint = chartView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        chartBottomConstraint?.priority = UILayoutPriority(1000)
        chartFullWidthConstraint = chartView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        chartMarginWidthConstraint = chartView.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -10)
        
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            chartView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            topBarBg.topAnchor.constraint(equalTo: view.topAnchor),
            topBarBg.bottomAnchor.constraint(equalTo: view.safeTopAnchor),
            chartBottomConstraint!,
            chartFullWidthConstraint!,
            chartTopConstraint,
            chartHeightConstraint
        ])
    }
    
    
}

extension CoinDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init(style: .default, reuseIdentifier: "ddd")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledDistance = scrollView.contentOffset.y + UIScreen.main.bounds.height
        let trigger = UIScreen.main.bounds.height / 4
        
        chartBottomConstraint?.constant = -scrolledDistance
        chartView.layoutIfNeeded()
        
        if (scrolledDistance > trigger) {
            chartFullWidthConstraint?.isActive = false
            chartMarginWidthConstraint?.isActive = true
            setTheme(.white)
        } else {
            chartMarginWidthConstraint?.isActive = false
            chartFullWidthConstraint?.isActive = true
            setTheme(.clear)
        }
        
        UIView.animate(withDuration: K.Design.AnimationTime) {
            self.chartView.layoutIfNeeded()
        }
    }
    
    private func setTheme(_ status: ThemeStatus) {
        let bar = navigationController?.navigationBar
        
        UIView.animate(withDuration: K.Design.AnimationTime) {
            if (status == .clear && self.currentTheme == .white) {
                bar?.tintColor = UIColor.white
                self.topBarBg.backgroundColor = UIColor.clear
                self.navigationController?.navigationBar.barStyle = .black
            } else if (status == .white && self.currentTheme == .clear) {
                bar?.tintColor = UIColor.theme.textDark.value
                self.topBarBg.backgroundColor = UIColor.white
                self.navigationController?.navigationBar.barStyle = .default
            }
        }
        
        currentTheme = status
    }
    
    
}
