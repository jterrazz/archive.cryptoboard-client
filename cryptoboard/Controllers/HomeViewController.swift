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
        field.attributedPlaceholder = NSAttributedString.init(string: "Search any coins", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)])
        
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
    lazy var scrollView = UIScrollView()
    lazy var topBackgroundWithAngle = BackgroundAngleView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarTouch(_:)))
        searchBar.addGestureRecognizer(searchTapGesture)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.theme.bg.value
        
        firstHeader.setup(title: "Personnal", borderColor: UIColor.theme.darkBg.value)
        secondeHeader.setup(title: "Coins", borderColor: UIColor.theme.darkBg.value)
        myWallet.addShadow()
        
        topBackgroundWithAngle.gradientColors = [
            UIColor.theme.custom(hexString: "#0d64d7").value.cgColor,
            UIColor.theme.custom(hexString: "#5d9bec").value.cgColor,
//            UIColor.theme.custom(hexString: "#4158D0").value.cgColor,
        ]
        
        view.addSubviewsAutoConstraints([topBackgroundWithAngle])
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
            "underWallet": underWallet,
            "angleBg": topBackgroundWithAngle
        ]
        let constraints = [
            "H:|[angleBg]|",
            "V:|[angleBg(300)]",
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
        let transition = CATransition()
        
        transition.duration = K.Design.AnimationTime
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCAFillModeForwards
        
        tabBarController?.view.layer.add(transition, forKey: nil)
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc private func handleSearchBarTouch(_ sender: UITapGestureRecognizer) {
        let vc = SearchController()
        let transition = CATransition()
        
        transition.duration = K.Design.AnimationTime
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
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
