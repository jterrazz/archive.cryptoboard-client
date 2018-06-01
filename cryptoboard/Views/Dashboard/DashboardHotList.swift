//
//  DashboardHotList.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 29/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class DashboardHotList: UICollectionViewCell {
    
    private let COIN_LIST_CELL_ID: String = "coin-list-cell-id"
    
    var navigationController: UINavigationController?
    
    lazy var hotTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoinListCell.self, forCellReuseIdentifier: COIN_LIST_CELL_ID)
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(hotTableView)
        
        NSLayoutConstraint.activate([
            hotTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hotTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hotTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hotTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    
}

extension DashboardHotList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: COIN_LIST_CELL_ID, for: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CoinDetailController()

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
        
}
