//
//  ViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 19/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit
import PinterestSegment
import Charts

class DashboardController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    private let HOT_LIST_CELL_ID = "dashboard-hot-list-cell-id"
    private let CHART_CELL_ID = "dashboard-chart-cell-id"
    
    let titles = ["Hot list", "My wallet", "Bitcoin", "Ethereum", "Ripple", "EOS"]
    var showingDetailedHover: Bool = false
    var showingHotList: Bool = false
    var segmentWasSelected: Bool = false
    
    // Reload the hoverTableView
    var currentSegment: UInt = 1
    
    lazy var dashboardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let dashboardCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        dashboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dashboardCollectionView.contentInsetAdjustmentBehavior = .never
        dashboardCollectionView.isPagingEnabled = true
        dashboardCollectionView.bounces = false
        dashboardCollectionView.showsVerticalScrollIndicator = false
        dashboardCollectionView.showsHorizontalScrollIndicator = false
        
        dashboardCollectionView.delegate = self
        dashboardCollectionView.dataSource = self
        
        dashboardCollectionView.register(DashboardHotList.self, forCellWithReuseIdentifier: HOT_LIST_CELL_ID)
        dashboardCollectionView.register(DashboardChart.self, forCellWithReuseIdentifier: CHART_CELL_ID)
        
        return dashboardCollectionView
    }()
    
    lazy var segmentView: PinterestSegment = {
        var style = PinterestSegmentStyle()
        style.indicatorColor = UIColor.white
        style.selectedTitleColor = UIColor.gradients.purple.value.first!
        
        let segmentView = PinterestSegment(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 60), segmentStyle: style, titles: titles)
        segmentView.backgroundColor = UIColor.clear
        segmentView.layer.addBorder(edge: .bottom, color: UIColor.theme.border.value, thickness: 1)
        segmentView.setSelectIndex(index: 1)
        segmentView.valueChange = self.segmentViewDidSelect
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentView
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.delegate = self
        bar.isTranslucent = true
        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.tintColor = UIColor.white
        bar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return bar
    }()
    
    lazy var navigationBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gradients.purple.value.first
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
//        navigationController?.navigationBar.backgroundColor = UIColor.theme.textDark.value
        
        navigationController?.delegate = self
        view.backgroundColor = UIColor.theme.bg.value
        view.addSubview(navigationBackground)
        view.addSubview(navigationBar)
        view.addSubview(segmentView)
        view.addSubview(dashboardCollectionView)
        
        let views: [String: Any] = [
            "DCV": dashboardCollectionView,
            "segment": segmentView,
            "navBar": navigationBar,
            "bgBar": navigationBackground
        ]
        let constraints = [
            "V:[navBar]-(-2)-[segment(60)][DCV]|",
            "H:|[segment]|",
            "H:|[DCV]|",
            "H:|[navBar]|",
            "H:|[bgBar]|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeTopAnchor),
            navigationBackground.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBackground.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
        dashboardCollectionView.reloadData()
        dashboardCollectionView.reloadItems(at: [IndexPath.init(row: 1, section: 0)])
        dashboardCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
    }

    private func setupNavBar() {
        let navItem = UINavigationItem.init(title: "amazing")
        
//        self.title = "Cryptoboard"
//        if let fontStyle = UIFont.init(name: "Pacifico", size: 23) {
//            let titleLabel = UILabel.init(frame: CGRect.zero)
//            titleLabel.text = "Cryptobboard"
//            titleLabel.font = fontStyle
//            titleLabel.textAlignment = .center
//            titleLabel.adjustsFontSizeToFitWidth = true
//            titleLabel.textColor = UIColor.theme.topBarEl.value
//            navigationItem.titleView = titleLabel
//        }
//
//        // BarButtons
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate)
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(searchImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(handleSearchBtn(_:)), for: .touchUpInside)
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        
        let userImage = UIImage(named: "menu_icon")?.withRenderingMode(.alwaysTemplate)
        let userButton = UIButton(type: .custom)
        userButton.setImage(userImage, for: .normal)
        userButton.imageView?.contentMode = .scaleAspectFit
        userButton.addTarget(self, action: #selector(handleSettingsBtn(_:)), for: .touchUpInside)
        let userButtonItem = UIBarButtonItem(customView: userButton)

        NSLayoutConstraint.activate([
            userButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            userButton.widthAnchor.constraint(equalToConstant: 28),
            searchButton.widthAnchor.constraint(equalToConstant: 28)
        ])

        navItem.leftBarButtonItem = userButtonItem
        navItem.rightBarButtonItem = searchButtonItem
        navigationBar.setItems([navItem], animated: false)
    }
    
    // ===================
    // ===== ACTIONS =====
    // ===================
    
    @objc private func handleSearchBtn(_ sender: UIButton) {
        let searchController = SearchController()
        
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc private func handleSettingsBtn(_ sender: UIButton) {
        let settingsController = SettingsController()
        
        navigationController?.present(settingsController, animated: true, completion: nil)
    }
    
    
}

extension DashboardController: UINavigationBarDelegate, UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension DashboardController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let hotCell = collectionView.dequeueReusableCell(withReuseIdentifier: HOT_LIST_CELL_ID, for: indexPath) as! DashboardHotList
            hotCell.setup(navigationController: self.navigationController)
            
            return hotCell
        default:
            let chartCell = collectionView.dequeueReusableCell(withReuseIdentifier: CHART_CELL_ID, for: indexPath) as! DashboardChart
            chartCell.navigationController = navigationController
            chartCell.delegate = self
            chartCell.setupForCurrency(currency: Currency.init(id: 0, name: "d", diminutive: "d", imageName: nil))
            currentSegment == 1 ? chartCell.setupToWallet() : chartCell.setupToCurrency()
            
            return chartCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let cell = getCurrentCell() {
            let currentIndex = self.dashboardCollectionView.indexPath(for: cell)?.row
            if (currentIndex == nil) {
                return
            }
            
            // If user scrolled (did not use the top segmentedView)
            if (!segmentWasSelected) {
                currentSegment = UInt(currentIndex!)
            }
            if (currentSegment >= 1) {
                updateChartCell()
            }
            segmentWasSelected = false
            
        }
    }
    
    private func getCurrentCell() -> UICollectionViewCell? {
        let currentCells = self.dashboardCollectionView.visibleCells
        
        return currentCells.first
    }
    
    
}

// Segment functions
extension DashboardController {
    
    private func segmentViewDidSelect(index: Int) {
        currentSegment = UInt(index)
        segmentWasSelected = true
        let hadToScroll = currentSegment == 0 ? showHotList() : hideHotList()
        
        // If the view had to scroll, we trigger the update with scrollViewDidEndScrollingAnimation
        if (currentSegment >= 1 && !hadToScroll) {
            // udpate chart data
            updateChartCell()
            segmentWasSelected = false
        }
    }
    
    private func updateChartCell() {
        let cell = dashboardCollectionView.cellForItem(at: IndexPath.init(row: 1, section: 0)) as? DashboardChart
        currentSegment == 1 ? cell?.setupToWallet() : cell?.setupToCurrency()
    }
    
    private func showHotList() -> Bool {
        var didChange = false
        if (!showingHotList) {
            dashboardCollectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            didChange = true
        }
        showingHotList = true
        
        return didChange
    }
    
    private func hideHotList() -> Bool {
        var didChange = false
        if (showingHotList) {
            dashboardCollectionView.selectItem(at: IndexPath.init(row: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            didChange = true
        }
        showingHotList = false
        
        return didChange
    }
    
    
}

extension DashboardController: DashboardChartDelegate {
    
    public func changeTheme(_ type: ThemeStatus) {
        let isClear = type == .clear
        
        if let color = isClear ? UIColor.white : UIColor.gradients.purple.value.first, let oppositeColor = !isClear ? UIColor.white : UIColor.gradients.purple.value.first {
            
            UIView.animate(withDuration: K.Design.AnimationTime) {
                self.navigationBackground.backgroundColor = color
            }
        }
    }
    
    
}

