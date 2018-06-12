//
//  WelcomeFollowViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class WelcomeFollowViewController: UIViewController {
    
    private let FOLLOW_COIN_CELL_ID = "follow-coin-cell-id"
    
    let TABLEVIEW_TOP_CONSTRAINT: CGFloat = 96
    let TABLEVIEW_SIDE_CONSTRAINT: CGFloat = 32
    
    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    lazy var followTableView = UITableView()
    lazy var followContainer = UIView()
    lazy var searchBar = UITextField()
    lazy var titleLabel = UILabel()
    
    var coinList = [Currency]()
    var coinResults = [Currency]() {
        didSet {
            followTableView.reloadData()
        }
    }
    
    var tableViewTopConstraint: NSLayoutConstraint?
    var tableViewLeftConstraint: NSLayoutConstraint?
    var tableViewRightConstraint: NSLayoutConstraint?
    
    // TODO Add animation to say loading coin list
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        CurrencyController.getList(limit: 999999) { (currencies) in
            self.coinList = currencies
            self.setDataForEmptySearch()
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "Search any coin"
        searchBar.autocorrectionType = .no
        searchBar.addTarget(self, action: #selector(handleTextChange(_:)), for: .editingChanged)
        followTableView.delegate = self
        followTableView.dataSource = self
        followTableView.register(FollowCoinCell.self, forCellReuseIdentifier: FOLLOW_COIN_CELL_ID)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.clear
        
        waveBackground.opposite = true
        
        followTableView.layer.cornerRadius = K.Design.CornerRadius
        followTableView.separatorStyle = .none
        followContainer.layer.cornerRadius = K.Design.CornerRadius
        followContainer.addShadow()
        followContainer.layer.borderWidth = 1
        followContainer.layer.borderColor = UIColor.theme.border.value.cgColor
        searchBar.backgroundColor = UIColor.clear
        searchBar.layer.addBorder(edge: .bottom, color: UIColor.theme.border.value, thickness: 1)
        searchBar.addPadding(.left(16))
        searchBar.font = UIFont.systemFont(ofSize: 15)
        followContainer.backgroundColor = UIColor.white
        
        nextButton.styleForHoverGradient()
        nextButton.addTarget(self, action: #selector(triggerNext(_:)), for: .touchUpInside)
        nextButton.setTitle("CONFIRM", for: .normal)
        
        view.addSubviewsAutoConstraints([nextButton, waveBackground, followContainer, titleLabel])
        followContainer.addSubviewsAutoConstraints([followTableView, searchBar])
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views = [
            "wave": waveBackground,
            "FTV": followTableView,
            "search": searchBar
        ]
        let constraints = [
            "H:|[wave]|",
            "V:[wave(320)]",
            "H:|[FTV]|",
            "H:|[search]|",
            "V:|[search(44)][FTV]|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        tableViewTopConstraint = followContainer.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: TABLEVIEW_TOP_CONSTRAINT)
        tableViewLeftConstraint = followContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: TABLEVIEW_SIDE_CONSTRAINT)
        tableViewRightConstraint = followContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -TABLEVIEW_SIDE_CONSTRAINT)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -48),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            followContainer.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -64),
            tableViewTopConstraint!,
            tableViewRightConstraint!,
            tableViewLeftConstraint!
            ])
    }
    
    @objc private func triggerNext(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        if (!followContainer.frame.contains(location)) {
            searchBar.resignFirstResponder()
        }
    }
    
    
}

extension WelcomeFollowViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FOLLOW_COIN_CELL_ID, for: indexPath) as! FollowCoinCell
        let currentCoin = coinResults[indexPath.row]
        
        cell.setup(name: currentCoin.name, image: nil, followed: false)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    private func setDataForEmptySearch() {
        coinResults = Array(coinList.prefix(100))
    }
    
    
}

extension WelcomeFollowViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableViewTopConstraint?.constant = 16
        tableViewRightConstraint?.constant = -16
        tableViewLeftConstraint?.constant = 16
        animateChange()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableViewTopConstraint?.constant = TABLEVIEW_TOP_CONSTRAINT
        tableViewRightConstraint?.constant = -TABLEVIEW_SIDE_CONSTRAINT
        tableViewLeftConstraint?.constant = TABLEVIEW_SIDE_CONSTRAINT
        animateChange()
    }
    
    private func animateChange() {
        UIView.animate(withDuration: K.Design.AnimationTime) {
            self.view.layoutIfNeeded()
        }
    }
    
}
