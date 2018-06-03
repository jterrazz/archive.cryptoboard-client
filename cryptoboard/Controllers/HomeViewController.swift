//
//  HomeViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 02/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

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
    
    lazy var myWallet: UIView = {
        let container = UIView()
        container.layer.cornerRadius = K.Design.CornerRadius
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViews() {
        let headerTitle = UILabel()
        headerTitle.text = "Personnel"
        headerTitle.textColor = UIColor.theme.textDark.value
        headerTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let secondHeaderTitle = UILabel()
        secondHeaderTitle.text = "Followed coins"
        secondHeaderTitle.textColor = UIColor.theme.textDark.value
        secondHeaderTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        view.backgroundColor = UIColor.theme.bg.value
        
        view.addSubviewAutoConstraints(searchBar)
        view.addSubviewAutoConstraints(scrollView)
        scrollView.addSubviewAutoConstraints(headerTitle)
        scrollView.addSubviewAutoConstraints(secondHeaderTitle)
        scrollView.addSubviewAutoConstraints(cardCollectionView)
        scrollView.addSubviewAutoConstraints(myWallet)
        
        let views = [
            "scroll": scrollView,
            "search": searchBar,
            "header1": headerTitle,
            "header2": secondHeaderTitle,
            "cards": cardCollectionView,
            "wallet": myWallet
        ]
        let constraints = [
            "H:|[scroll]|",
            "H:|-18-[wallet]-18-|",
            "H:|[cards]|",
            "H:|-17-[search]-17-|",
            "H:|-18-[header1]-18-|",
            "H:|-18-[header2]-18-|",
            "V:[search]-18-[scroll]|",
            "V:|-18-[header1]-18-[wallet(60)]-18-[header2]-12-[cards]-12-|",
        ]
        
        
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 18),
            searchBar.heightAnchor.constraint(equalToConstant: SEARCH_BAR_HEIGHT),
            cardCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            cardCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65)
        ])
        
        view.layoutIfNeeded()
        cardCollectionView.reloadData()
        myWallet.applyGradient(colours: UIColor.gradients.purple.value)
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
        let cardWidth = cardCollectionView.bounds.width - 50
        
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
        let vc = DashboardController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
