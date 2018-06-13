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
    
    let TABLEVIEW_TOP_CONSTRAINT: CGFloat = 32
    let TABLEVIEW_SIDE_CONSTRAINT: CGFloat = 32
    
    lazy var nextButton = RoundedButton()
    lazy var waveBackground = WaveView()
    lazy var followTableView = UITableView()
    lazy var followContainer = UIView()
    lazy var searchBar = UITextField()
    lazy var titleLabel = UILabel()
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "left-arrow", in: Bundle.main, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    var followedSymbols = [String]()
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
        nextButton.addTarget(self, action: #selector(triggerNextButton(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(triggerBackButton(_:)), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.clear
        
        waveBackground.opposite = true
        
        followTableView.layer.cornerRadius = K.Design.CornerRadius
        followTableView.separatorStyle = .none
        followTableView.backgroundColor = UIColor.white
        followContainer.backgroundColor = UIColor.theme.bg.value
        followContainer.layer.cornerRadius = K.Design.CornerRadius
        followContainer.addShadow()
        followContainer.layer.borderWidth = 1
        followContainer.layer.borderColor = UIColor.theme.border.value.cgColor
        searchBar.backgroundColor = UIColor.clear
        searchBar.layer.addBorder(edge: .bottom, color: UIColor.theme.border.value, thickness: 1)
        searchBar.addPadding(.left(16))
        searchBar.font = UIFont.systemFont(ofSize: 15)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = "Pick your favorites coins"
        titleLabel.textColor = UIColor.white
        
        nextButton.styleForHoverGradient()
        nextButton.setTitle("CONFIRM", for: .normal)
        
        view.addSubviewsAutoConstraints([nextButton, waveBackground, followContainer, titleLabel, backButton])
        followContainer.addSubviewsAutoConstraints([followTableView, searchBar])
        setupConstraints()
    }
    
    private func setupConstraints() {
        let views = [
            "wave": waveBackground,
            "FTV": followTableView,
            "search": searchBar,
            "back": backButton
        ]
        let constraints = [
            "H:|[wave]|",
            "V:[wave(320)]",
            "H:|[FTV]|",
            "H:|[search]|",
            "V:|[search(44)][FTV]|",
            "H:|-16-[back(20)]",
            "V:[back(20)]",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        
        tableViewTopConstraint = followContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TABLEVIEW_TOP_CONSTRAINT)
        tableViewLeftConstraint = followContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: TABLEVIEW_SIDE_CONSTRAINT)
        tableViewRightConstraint = followContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -TABLEVIEW_SIDE_CONSTRAINT)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -64),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            waveBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            followContainer.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -32),
            backButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            tableViewTopConstraint!,
            tableViewRightConstraint!,
            tableViewLeftConstraint!
            ])
    }
    
    @objc private func triggerNextButton(_ sender: UIButton) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(2)
    }
    
    @objc private func triggerBackButton(_ sender: UIImageView) {
        let parentVC = self.parent as? WelcomeViewController
        
        parentVC?.setViewController(0)
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

extension WelcomeFollowViewController: FollowCoinDelegate {
    
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

extension WelcomeFollowViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        followTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
