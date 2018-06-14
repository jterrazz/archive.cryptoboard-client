//
//  FollowCoinView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 13/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class FollowCoinView: UIView {
    
    private let FOLLOW_COIN_CELL_ID = "follow-coin-cell-id"
    private let EMPTY_FOLLOW_COIN_CELL_ID = "empty-follow-coin-cell-id"
    private let ERROR_FOLLOW_COIN_CELL_ID = "error-follow-coin-cell-id"
    
    let userSettingsController = UserSettingsController()
    
    lazy var followTableView = UITableView()
    lazy var searchBar = UITextField()
    
    var delegate: FollowCoinViewDelegate?
    var networkError = false {
        didSet {
            DispatchQueue.main.async {
                self.followTableView.reloadData()
            }
        }
    }
    
    var followedSymbols = [String]()
    var coinList = [Currency]() {
        didSet {
            DispatchQueue.main.async {
                self.setDataForEmptySearch()
            }
        }
    }
    var coinResults = [Currency]() {
        didSet {
            self.followTableView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        addShadow()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let userSettings = userSettingsController.get()
        if let followed = userSettings?.followedCurrencies {
            self.followedSymbols = followed
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "Search any coin"
        searchBar.autocorrectionType = .no
        searchBar.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)
        followTableView.delegate = self
        followTableView.dataSource = self
        followTableView.register(FollowCoinCell.self, forCellReuseIdentifier: FOLLOW_COIN_CELL_ID)
        followTableView.register(FollowCoinEmptyCell.self, forCellReuseIdentifier: EMPTY_FOLLOW_COIN_CELL_ID)
        followTableView.register(FollowCoinErrorCell.self, forCellReuseIdentifier: ERROR_FOLLOW_COIN_CELL_ID)
        
        setupViews()
    }
    
    private func setupViews() {
        addSubviewsAutoConstraints([followTableView, searchBar])
        
        searchBar.backgroundColor = UIColor.clear
        searchBar.layer.addBorder(edge: .bottom, color: UIColor.theme.border.value, thickness: 1)
        searchBar.addPadding(.left(16))
        searchBar.font = UIFont.systemFont(ofSize: 15)
        
        followTableView.layer.cornerRadius = K.Design.CornerRadius
        followTableView.separatorStyle = .none
        followTableView.backgroundColor = UIColor.white
        
        let views = [
            "FTV": followTableView,
            "search": searchBar
            ]
        let constraints = [
            "H:|[FTV]|",
            "H:|[search]|",
            "V:|[search(44)][FTV]|",
            ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    func saveFollowedCurrencies() throws {
        try UserSettingsController().update { (settings) in
            for symbol in followedSymbols {
                settings.followCurrency(symbol)
            }
        }
    }
    

}

extension FollowCoinView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (coinResults.count == 0) {
            return 1
        }
        
        return coinResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (coinResults.count == 0 && networkError) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ERROR_FOLLOW_COIN_CELL_ID, for: indexPath) as! FollowCoinErrorCell
            
            cell.delegate = self
            return cell
        } else if (coinResults.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: EMPTY_FOLLOW_COIN_CELL_ID, for: indexPath) as! FollowCoinEmptyCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FOLLOW_COIN_CELL_ID, for: indexPath) as! FollowCoinCell
        let currentCoin = coinResults[indexPath.row]
        let isFollowed = (followedSymbols.index(of: currentCoin.diminutive) != nil) ? true : false
        
        cell.setup(currency: currentCoin, selected: isFollowed)
        cell.followButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (coinResults.count == 0) {
            return tableView.frame.height
        }
        
        return 42
    }
    
    @objc private func handleTextChange(_ sender: UITextField) {
        let results = Currency.filterList(searchBar.text, coinList: coinList)
        
        if let safeResults = results {
            coinResults = safeResults
        } else {
            setDataForEmptySearch()
        }
    }
    
    func setDataForEmptySearch() {
        coinResults = Array(coinList.prefix(100))
    }
    
    
}

extension FollowCoinView: FollowCoinCellDelegate {
    
    func didSelectButton(currency: Currency) {
        followedSymbols.append(currency.diminutive)
    }
    
    func didUnselectButton(currency: Currency) {
        let symbol = currency.diminutive
        
        if let index = followedSymbols.index(of: symbol) {
            followedSymbols.remove(at: index)
        }
    }
    
    
}

extension FollowCoinView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        followTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.delegate?.textFieldDidStartEditing?()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidStartEditing?()
    }
    
}

extension FollowCoinView: FollowCoinErrorCellDelegate {
    
    func didAskForReload() {
        delegate?.askedToReloadData()
    }
}

@objc protocol FollowCoinViewDelegate {
    
    @objc optional func textFieldDidStartEditing()
    @objc optional func textFieldDidStopEditing()
    func askedToReloadData()
    
    
}
