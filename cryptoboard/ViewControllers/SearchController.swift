//
//  SearchController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController, UIGestureRecognizerDelegate {
    
    private let CURRENCY_CELL_ID = "search-currency-cell"
    
    var allCurrencies = [Currency]()
    var searchResults = [Currency]() {
        didSet {
            resultTableView.reloadData()
        }
    }
    
    lazy var searchBar: UITextField = {
        let backImage = UIImage.init(named: "left-arrow")
        let frame = CGRect.init(x: 0, y: 0, width: 44, height: 17)
        let input = UITextField.searchBar(cornerRadius: 22, theme: .clear, leftImage: backImage, leftImageFrame: frame)

        // Events
        let backTouch = UITapGestureRecognizer(target: self, action: #selector(handleBackAction(_:)))
        input.leftView?.addGestureRecognizer(backTouch)
        input.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)

        return input
    }()
    
    lazy var resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        tableView.separatorColor = UIColor.theme.border.value
        
        tableView.register(SearchCurrencyCell.self, forCellReuseIdentifier: CURRENCY_CELL_ID)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubviewsAutoConstraints([searchBar, resultTableView])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8),
            searchBar.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 0),
            searchBar.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        let views = [
            "search": searchBar,
            "results": resultTableView
        ]
        let constraints = [
            "H:|[results]|",
            "V:[search]-8-[results]|"
        ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        searchResults.removeAll()
        CurrencyController.getList(limit: 999999) { (currencies) in
            self.allCurrencies = currencies
            // TODO Update list
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.searchBar.becomeFirstResponder()
    }
    
    @objc private func handleTextChange(_ sender: UITextField) {
        if let searched = searchBar.text?.lowercased() {
            searchResults = allCurrencies.filter({ (currency) -> Bool in
                let nameMatch = currency.name.lowercased().range(of: searched)
                let symbolMatch = currency.diminutive.lowercased().range(of: searched)
                
                let match = (nameMatch != nil || symbolMatch != nil) ? true : false
                
                return match
            })
        } else {
            // TODO Empty search = recent or most famous
        }
    }
    
    @objc private func handleBackAction(_ sender: UITapGestureRecognizer) {
        let transition = CATransition()
        transition.duration = K.Design.AnimationTime
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CURRENCY_CELL_ID, for: indexPath) as! SearchCurrencyCell
        
        cell.setup(currency: searchResults[indexPath.row])
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = searchResults[indexPath.row]
        let vc = CoinDetailController(currency: currency)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
