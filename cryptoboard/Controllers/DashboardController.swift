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

fileprivate let X_AXIS_NB_VALUES: Double = 3
fileprivate let HOVER_CELL_ID: String = "hover-cell-id"
fileprivate let HOVER_CELL_EMPTY_ID: String = "hover-cell-empty-id"
fileprivate let HOVER_FOLLOWED_CELL_ID: String = "hover-cell-followed-id"
let COIN_LIST_CELL_ID: String = "coin-list-cell-id"

class DashboardController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    enum TableViewStatus {
        case wallet, coin
    }
    
    let titles = ["Hot list", "My wallet", "Bitcoin", "Ethereum", "Ripple", "EOS"]
    var hotListDataService: HotListDataService?
    var tableViewStatus: TableViewStatus = .wallet
    var showingHotList: Bool = false
    var showingDetailedHover: Bool = false
    
    // Reload the hoverTableView
    var currentSegment: UInt = 1 {
        didSet {
            handleSegmentChange(currentSegment: currentSegment)
            if (currentSegment > 1) {
                updateChartData()
            }
        }
    }
    
    lazy var chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()
    
    lazy var segmentView: PinterestSegment = {
        var style = PinterestSegmentStyle()
        style.indicatorColor = UIColor.theme.redClear.value
        style.selectedTitleColor = UIColor.white
        
        let segmentView = PinterestSegment(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 60), segmentStyle: style, titles: titles)
        segmentView.backgroundColor = UIColor.white
        segmentView.layer.addBorder(edge: .bottom, color: UIColor.theme.border.value, thickness: 1)
        segmentView.setSelectIndex(index: 1)
        segmentView.valueChange = self.segmentViewDidSelect
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentView
    }()
    
    lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "$ 02222222"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var hoverTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoverEmptyCell.self, forCellReuseIdentifier: HOVER_CELL_EMPTY_ID)
        tableView.register(HoverFollowedCell.self, forCellReuseIdentifier: HOVER_FOLLOWED_CELL_ID)
        tableView.register(HoverWalletCell.self, forCellReuseIdentifier: HOVER_CELL_ID)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var hotTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = hotListDataService
        tableView.dataSource = hotListDataService
        tableView.register(CoinListCell.self, forCellReuseIdentifier: COIN_LIST_CELL_ID)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var hotView: UIView = {
        let hotView = UIView()
        hotView.backgroundColor = UIColor.red
        hotView.translatesAutoresizingMaskIntoConstraints = false
        
        return hotView
    }()
    
    var hotViewBottomConstraint: NSLayoutConstraint?
    var hotViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // TEMP
        let months = ["Jan", "Feb", "Mar"]
        let unitsSold = [10.0, 4.0, 6.0]
        
        hotListDataService = HotListDataService(navigationController: self.navigationController)
        
        view.backgroundColor = UIColor.theme.bg.value
        view.addSubview(chartView)
        view.addSubview(currentPriceLabel)
        view.addSubview(hoverTableView)
        view.addSubview(hotView)
        view.addSubview(segmentView)
        
        hotView.addSubview(hotTableView)
        
        setupNavBar()
        setupChart(months, values: unitsSold)
        
        hoverTableView.backgroundColor = UIColor.clear
        hotTableView.backgroundColor = UIColor.theme.bg.value
        
        let views: [String: Any] = [
            "chart": chartView,
            "segment": segmentView,
            "hover": hoverTableView,
            "hot": hotView,
            "HTB": hotTableView,
            "price": currentPriceLabel
        ]
        let constraints = [
            "V:[segment(60)]-18-[price]-150-[chart]|",
            "V:[segment][hover]|",
            "V:[segment][hot]",
            "H:|[chart]|",
            "H:|[hot]|",
            "H:|[segment]|",
            "H:|[hover]|",
            "V:|[HTB]|",
            "H:|[HTB]|",
        ]
        
        hotViewBottomConstraint = hotView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        hotViewHeightConstraint = hotView.heightAnchor.constraint(equalToConstant: 0)
        hotViewHeightConstraint?.isActive = true
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2),
            currentPriceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
    }

    private func setupNavBar() {
        self.title = "Cryptoboard"
        if let fontStyle = UIFont.init(name: "Pacifico", size: 23) {
            let titleLabel = UILabel.init(frame: CGRect.zero)
            titleLabel.text = "Cryptobboard"
            titleLabel.font = fontStyle
            titleLabel.textAlignment = .center
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = UIColor.theme.topBarEl.value
            navigationItem.titleView = titleLabel
        }
        
        // BarButtons
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate)
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(searchImage, for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(handleSearchBtn(_:)), for: .touchUpInside)
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        
        let userImage = UIImage(named: "user_icon")?.withRenderingMode(.alwaysTemplate)
        let userButton = UIButton(type: .custom)
        userButton.setImage(userImage, for: .normal)
        userButton.imageView?.contentMode = .scaleAspectFit
        userButton.addTarget(self, action: #selector(handleSettingsBtn(_:)), for: .touchUpInside)
        let userButtonItem = UIBarButtonItem(customView: userButton)
        
        NSLayoutConstraint.activate([
            userButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            userButton.widthAnchor.constraint(equalToConstant: 26),
            searchButton.widthAnchor.constraint(equalToConstant: 26)
        ])
        
        navigationItem.leftBarButtonItem = userButtonItem
        navigationItem.rightBarButtonItems = [searchButtonItem]
    }
    
    // ===================
    // ===== ACTIONS =====
    // ===================
    
    private func updateChartData() { // TODO Update func
        let currency = Currency(id: 0, name: "Bitcoin", diminutive: "BTC", imageName: nil)
        
        CurrencyController.getCurrencyState(currencies: [currency]) { (currencies) in
            if (currencies.count == 1) {
                self.currentPriceLabel.text = currencies[0].liveData?.price?.format(f: ".2")
            }
        }
    }
    
    private func handleSegmentChange(currentSegment: UInt) {
        currentSegment == 0 ? showHotList() : hideHotList()
        
        if (currentSegment >= 1) {
            let oldCellNb = getNumberOfHoverRows(status: tableViewStatus)
            let newCellNb = getNumberOfRowsPerSegment(segment: currentSegment)
            
            let addNb = newCellNb - oldCellNb > 0 ? newCellNb - oldCellNb : 0
            let removeNb = newCellNb - oldCellNb < 0 ? oldCellNb - newCellNb : 0
            let updateNb = oldCellNb - removeNb
            
            var addArray: [IndexPath] = []
            var removeArray: [IndexPath] = []
            var updateArray: [IndexPath] = []
            
            for i in 0..<addNb {
                addArray.append(IndexPath(row: i + updateNb, section: 0))
            }
            for i in 0..<removeNb {
                removeArray.append(IndexPath(row: i + updateNb, section: 0))
            }
            for i in 0..<updateNb {
                updateArray.append(IndexPath(row: i, section: 0))
            }
            
            if (addArray.count > 0) {
                hoverTableView.insertRows(at: addArray, with: .fade)
            }
            if (removeArray.count > 0) {
                hoverTableView.deleteRows(at: removeArray, with: .fade)
            }
            if (updateArray.count > 0) {
                hoverTableView.reloadRows(at: updateArray, with: .fade)
            }
            
            if (currentSegment > 1) {
                tableViewStatus = .coin
            } else if (currentSegment == 1) {
                tableViewStatus = .wallet
            }
        }
    }
    
    @objc private func handleSearchBtn(_ sender: UIButton) {
        let searchController = SearchController()
        
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc private func handleSettingsBtn(_ sender: UIButton) {
        let settingsController = SettingsController()
        
        navigationController?.present(settingsController, animated: true, completion: nil)
    }
    
    
}

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsPerSegment(segment: currentSegment)
    }
    
    private func getNumberOfRowsPerSegment(segment: UInt) -> Int {
        if (segment == 1) {
            return getNumberOfHoverRows(status: .wallet)
        } else {
            return getNumberOfHoverRows(status: .coin)
        }
    }
    
    private func getNumberOfHoverRows(status: TableViewStatus) -> Int {
        switch status {
        case .wallet:
            return 5
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HOVER_CELL_EMPTY_ID, for: indexPath) as! HoverEmptyCell
            cell.setup(height: getHoverCellHeight())
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: HOVER_CELL_ID, for: indexPath) as! HoverWalletCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: HOVER_FOLLOWED_CELL_ID, for: indexPath) as! HoverFollowedCell
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Chart animation
        if (scrollView.contentOffset.y < 0) {
            chartView.leftAxis.axisMinimum = -10 + Double(abs(scrollView.contentOffset.y).squareRoot())
        } else {
            chartView.leftAxis.axisMinimum = -10 - Double(scrollView.contentOffset.y)
        }
        
        chartView.notifyDataSetChanged()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: self.view).y
        
        if (!showingDetailedHover && velocity < 0) { // Scrolled up when hoverTableView is hidden
            hoverTableView.scrollToRow(at: IndexPath.init(row: 1, section: 0), at: .top, animated: true)
            showingDetailedHover = true
        } else if (true) { // Scrolled down when hoverTableView is close to row 1 TODO!!
            hoverTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            showingDetailedHover = false
        }
    }
    
    private func getHoverCellHeight() -> CGFloat {
        return hoverTableView.frame.height - 100
    }
    
    
}

extension DashboardController {
    
    private func segmentViewDidSelect(index: Int) {
        currentSegment = UInt(index)
    }
    
    private func hideHotList(animated: Bool = true) {
        if (self.showingHotList) {
            UIView.animate(withDuration: 0.3) {
                self.hotViewBottomConstraint?.isActive = false
                self.hotViewHeightConstraint?.isActive = true
                self.hotView.superview?.layoutIfNeeded()
            }
        }
        self.showingHotList = false
    }
    
    private func showHotList(animated: Bool = true) {
        if (!self.showingHotList) {
            UIView.animate(withDuration: 0.3) {
                self.hotViewHeightConstraint?.isActive = false
                self.hotViewBottomConstraint?.isActive = true
                self.hotView.superview?.layoutIfNeeded()
            }
        }
        self.showingHotList = true
    }
    
    
}

extension DashboardController: ChartViewDelegate {
    
    private func setupChart(_ dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        dataEntries.append(ChartDataEntry(x: -1, y: 10))
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        dataEntries.append(ChartDataEntry(x: 3, y: 6))
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
        chartDataSet.lineCapType = .round
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 0
        //        chartDataSet.setColor(Color.custom(hexString: "#FFFFFF").withAlpha(0.95))
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.setCircleColors(UIColor.white)
        chartDataSet.circleHoleColor = UIColor.theme.redClear.value
        chartDataSet.circleHoleRadius = 5
        let gradientColors = [UIColor.theme.redClear.value.cgColor, UIColor.theme.redDark.value.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1, 0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90)
        chartDataSet.fillAlpha = 1
        chartDataSet.circleRadius = 7
        let chartData = LineChartData(dataSet: chartDataSet)
        
        //        chartView.dragEnabled = false
        //        chartView.pinchZoomEnabled = false
        //        chartView.highlightPerTapEnabled = false
        //        chartView.highlightPerDragEnabled = false
        chartView.minOffset = 0
        
        //        chartView.xAxis.enabled = false
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        chartView.xAxis.labelTextColor = UIColor.theme.textIntermediate.value
        chartView.xAxis.valueFormatter = HomeChartStringFormatter()
        chartView.xAxis.drawGridLinesEnabled = false
        //        chartView.xAxis.setLabelCount(Int(X_AXIS_NB_VALUES) + 2, force: true)
        //        chartView.xAxis.centerAxisLabelsEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.granularity = 1
        //        chartView.xAxis.axisMaximum = X_AXIS_NB_VALUES - 0.8
        //        chartView.xAxis.axisMinimum = -0.2
        chartView.isUserInteractionEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.chartDescription?.enabled = false
        chartView.noDataText = "Data is not available"
        chartView.legend.enabled = false
        chartView.data = chartData
        chartView.leftAxis.axisMinimum = -10
        chartView.delegate = self
    }
    
    
}

class HomeChartStringFormatter: IAxisValueFormatter {
    
    var names: [String] = ["WEEK 1", "WEEK 2", "WEEK 3"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if (value < 0 || Int(value) >= names.count) {
            return ""
        } else {
            return String(describing: names[Int(value)])
        }
    }
    
    
}
