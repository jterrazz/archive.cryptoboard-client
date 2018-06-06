//
//  HomeViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 02/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    private let CARD_COIN_CELL_ID = "card-coin-cell-id"
    private let SEARCH_BAR_HEIGHT: CGFloat = 48
    
    var indexOfCellBeforeDragging: Int = 0
    
    lazy var scrollView = UIScrollView()
    
    lazy var searchBar: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.white
        field.layer.masksToBounds = false
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.theme.border.value.cgColor
        field.layer.cornerRadius = 5
        field.layer.shadowOffset = CGSize.init(width: 0, height: 8)
        field.layer.shadowRadius = 8
        field.layer.shadowColor = UIColor.theme.shadow.value.cgColor
        field.layer.shadowOpacity = 0.15
        field.attributedPlaceholder = NSAttributedString.init(string: "Search any currency", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)])
        
        let searchView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SEARCH_BAR_HEIGHT, height: 23))
        let iconImage = UIImage.init(named: "search_icon")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        searchView.image = iconImage
        searchView.contentMode = .scaleAspectFit
        searchView.tintColor = UIColor.theme.custom(hexString: "#c8c8c8").value
        
        field.leftView = searchView
        field.leftViewMode = .always
        
        return field
    }()
    
    lazy var cardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        
        collection.register(CardCoinCell.self, forCellWithReuseIdentifier: CARD_COIN_CELL_ID)
        
        return collection
    }()
    
    lazy var myWallet = WalletView()
    lazy var underWallet = UnderWalletView()
    lazy var firstHeader = HomeHeaderView()
    lazy var secondeHeader = HomeHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.theme.bg.value
        
        firstHeader.setup(title: "Personnal")
        secondeHeader.setup(title: "My coins")
        
        view.addSubviewAutoConstraints(searchBar)
        view.addSubviewAutoConstraints(scrollView)
        scrollView.addSubviewAutoConstraints(firstHeader)
        scrollView.addSubviewAutoConstraints(secondeHeader)
        scrollView.addSubviewAutoConstraints(cardCollectionView)
        scrollView.addSubviewAutoConstraints(myWallet)
        scrollView.addSubviewAutoConstraints(underWallet)
        
        let views = [
            "scroll": scrollView,
            "search": searchBar,
            "header1": firstHeader,
            "header2": secondeHeader,
            "cards": cardCollectionView,
            "wallet": myWallet,
            "underWallet": underWallet
        ]
        let constraints = [
            "H:|[scroll]|",
            "H:|-16-[underWallet]-16-|",
            "H:|-16-[wallet]-16-|",
            "H:|[cards]|",
            "H:|-16-[search]-16-|",
            "H:|-16-[header1]-16-|",
            "H:|-16-[header2]-16-|",
            "V:[search]-16-[scroll]|",
            "V:|-16-[header1]-16-[wallet]-16-[underWallet]-32-[header2][cards]-12-|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 18),
            searchBar.heightAnchor.constraint(equalToConstant: SEARCH_BAR_HEIGHT),
            cardCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            cardCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
        ])
        
        view.layoutIfNeeded()
        cardCollectionView.reloadData()
        
        let coinsCellGradient = [UIColor.theme.custom(hexString: "#ff7676").value.cgColor, UIColor.theme.custom(hexString: "#f54ea2").value.cgColor]
        let settingsCellGradient = [UIColor.theme.custom(hexString: "#00e9ff").value.cgColor, UIColor.theme.custom(hexString: "#3b8be7").value.cgColor]
        
        underWallet.coinsCell.setGradient(colors: coinsCellGradient, angle: 90)
        underWallet.settingsCell.setGradient(colors: settingsCellGradient, angle: 90)
        
        let allCoinsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAllCoinsTap(_:)))
        underWallet.coinsCell.addGestureRecognizer(allCoinsTap)
    }
    
    @objc private func handleAllCoinsTap(_ sender: UITapGestureRecognizer?) {
        if let fromView = tabBarController?.selectedViewController?.view, let viewControllers = tabBarController?.viewControllers {
            if (viewControllers.count < 2) { return }
            
            let toView = viewControllers[1].view
            
            UIView.transition(from: fromView, to: toView!, duration: K.Design.AnimationTime, options: UIViewAnimationOptions.transitionFlipFromBottom) { (finished) in
                self.tabBarController?.selectedIndex = 1
            }
        }
    }
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CARD_COIN_CELL_ID, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize()
    }
    
    //
    // Center collectionview cells
    //
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionView.bounds.width - calculateCellSize().width) / 2

        return UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    private func calculateCellSize() -> CGSize {
        let cardHeight = cardCollectionView.bounds.height
        let cardWidth = cardCollectionView.bounds.width - 48
        
        return CGSize.init(width: cardWidth, height: cardHeight)
    }
    
    private func indexOfCurrentCell() -> Int {
        let cellWidth = calculateCellSize().width
        let realOffset = cardCollectionView.contentOffset.x / cellWidth
        
        return Int(round(realOffset))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfCurrentCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMainCell = self.indexOfCurrentCell()
        let nbCells = collectionView(cardCollectionView, numberOfItemsInSection: 0)
        let swipeVelocityThreshold: CGFloat = 0.5
        
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < nbCells && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let mainCellIsTheCellBeforeDragging = indexOfMainCell == indexOfCellBeforeDragging
        let willChangeCellBecauseOfVelocity = mainCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if (willChangeCellBecauseOfVelocity) {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = calculateCellSize().width * CGFloat(snapToIndex)
            
            // Allow a better animation by keeping the velocity
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMainCell, section: 0)
            
            cardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CoinDetailController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
