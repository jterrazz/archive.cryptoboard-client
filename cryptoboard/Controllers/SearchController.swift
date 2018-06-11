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
        let input = UITextField()
        input.backgroundColor = UIColor.theme.inputBg.value
        input.attributedPlaceholder = NSAttributedString(string: "Search currencies", attributes: [NSAttributedStringKey.foregroundColor : UIColor.theme.textIntermediate.value])
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.cornerRadius = 22
        input.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        
        let backView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 17))
        let backImage = UIImage.init(named: "left-arrow")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backView.image = backImage
        backView.contentMode = .scaleAspectFit
        backView.tintColor = UIColor.theme.textIntermediate.value
        let backTouch = UITapGestureRecognizer(target: self, action: #selector(handleBackAction(_:)))
        backView.addGestureRecognizer(backTouch)
        backView.isUserInteractionEnabled = true
        
        input.leftView = backView
        input.leftViewMode = .always
        input.autocorrectionType = .no
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
        view.addSubview(searchBar)
        view.addSubview(resultTableView)
        
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
        let vc = CoinDetailController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
