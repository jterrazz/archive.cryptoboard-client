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

class DashboardController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    let titles = ["Hot list", "My wallet", "Bitcoin", "Ethereum", "Ripple", "EOS"]
    let hotListDataService = HotListDataService()
    
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
    
    lazy var hoverTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var hotTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = hotListDataService
        tableView.dataSource = hotListDataService
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // TEMP
        let months = ["Jan", "Feb", "Mar"]
        let unitsSold = [10.0, 4.0, 6.0]
        
        view.backgroundColor = UIColor.theme.bg.value
        view.addSubview(chartView)
        view.addSubview(segmentView)
        view.addSubview(hoverTableView)
        view.addSubview(hotTableView)
        
        hotTableView.isHidden = true
        
        setupNavBar()
        setupChart(months, values: unitsSold)
        hoverTableView.backgroundColor = UIColor.clear
        hoverTableView.separatorStyle = .none
        hoverTableView.register(HoverWalletCell.self, forCellReuseIdentifier: HOVER_CELL_ID)
        
        hotTableView.register(HoverWalletCell.self, forCellReuseIdentifier: "lol")
        
        let views: [String: Any] = [
            "chart": chartView,
            "segment": segmentView,
            "hover": hoverTableView,
            "hot": hotTableView
        ]
        let constraints = [
            "V:[segment(60)]-180-[chart]|",
            "V:[segment][hover]|",
            "V:[segment][hot]|",
            "H:|[chart]|",
            "H:|[hot]|",
            "H:|[segment]|",
            "H:|[hover]|"
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2)
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
    
    @objc private func handleSearchBtn(_ sender: UIButton) {
        let searchController = SearchController()
        
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc private func handleSettingsBtn(_ sender: UIButton) {
        let settingsController = SettingsController()
        
        navigationController?.present(settingsController, animated: true, completion: nil)
    }
    
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

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HOVER_CELL_ID, for: indexPath) as! HoverWalletCell
        let tableViewHeight = tableView.frame.height
        
        cell.setupConstraints(topMargin: tableViewHeight - 100)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) {
            chartView.leftAxis.axisMinimum = -10 + Double(abs(scrollView.contentOffset.y).squareRoot())
        } else {
            chartView.leftAxis.axisMinimum = -10 - Double(scrollView.contentOffset.y)
        }
        
        chartView.notifyDataSetChanged()
    }
    
    
}

extension DashboardController {
    
    private func segmentViewDidSelect(index: Int) {
        if (index == 0) {
            hotTableView.isHidden = false
        } else {
            hotTableView.isHidden = true
        }
    }
    
    
}

extension DashboardController: ChartViewDelegate {
    
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
