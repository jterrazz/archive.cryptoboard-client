//
//  DashboardChart.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 29/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

//fileprivate let X_AXIS_NB_VALUES: Double = 3

class DashboardChart: UICollectionViewCell {
    
    var tableViewStatus: TableViewStatus = .wallet
    var navigationController: UINavigationController?
    var delegate: DashboardChartDelegate?
    
    let CHART_WIDTH_OFFSET_CONSTANT: CGFloat = 180
    let HOVER_LABEL_BOTTOM: CGFloat = 100
    let TITLE_SIZE: CGFloat = 31
    let HOVER_CELL_ID: String = "hover-cell-id"
    let HOVER_CELL_EMPTY_ID: String = "hover-cell-empty-id"
    let HOVER_FOLLOWED_CELL_ID: String = "hover-cell-followed-id"
    
    lazy var chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()
    
    lazy var hoverTableView: UITableView = {
        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HoverEmptyCell.self, forCellReuseIdentifier: HOVER_CELL_EMPTY_ID)
        tableView.register(HoverFollowedCell.self, forCellReuseIdentifier: HOVER_FOLLOWED_CELL_ID)
        tableView.register(HoverWalletCell.self, forCellReuseIdentifier: HOVER_CELL_ID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()
    
    lazy var chartContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        return container
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Update 20 sec ago"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "BITCOIN"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "$ 10.000"
        label.font = UIFont.systemFont(ofSize: TITLE_SIZE, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.text = "more"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var chartContainerBottomConstraint: NSLayoutConstraint?
    var chartContainerFullWidthConstraint: NSLayoutConstraint?
    var chartContainerSmallWidthConstraint: NSLayoutConstraint?
    var chartWidthConstraint: NSLayoutConstraint?
    var hoverLabelBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hoverTableView.delegate = self
        hoverTableView.dataSource = self
        
        contentView.addSubview(chartContainer)
        contentView.addSubview(hoverTableView)
        chartContainer.addSubview(chartView)
        chartContainer.addSubview(subtitleLabel)
        chartContainer.addSubview(titleLabel)
        chartContainer.addSubview(topTitleLabel)
        chartContainer.addSubview(moreLabel)
        backgroundColor = UIColor.theme.bg.value

        chartContainerBottomConstraint = chartContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        chartContainerBottomConstraint?.priority = UILayoutPriority.init(1000)
        chartWidthConstraint = chartView.widthAnchor.constraint(equalTo: chartContainer.widthAnchor, constant: CHART_WIDTH_OFFSET_CONSTANT)
        chartContainerFullWidthConstraint = chartContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        chartContainerSmallWidthConstraint = chartContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10)
        hoverLabelBottomConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: -HOVER_LABEL_BOTTOM)
        
        NSLayoutConstraint.activate([
            chartContainerBottomConstraint!,
            chartContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            chartContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor),
            chartView.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 400),
            moreLabel.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            chartWidthConstraint!,
            hoverLabelBottomConstraint!,
            chartContainerFullWidthConstraint!
        ])
        
        let views = [
            "hover": hoverTableView,
            "subtitle": subtitleLabel,
            "title": titleLabel,
            "topTitle": topTitleLabel,
            "more": moreLabel
        ]
        let constraints = [
            "H:|[hover]|",
            "V:|[hover]|",
            "H:|-18-[subtitle]-18-|",
            "H:|-18-[topTitle]-18-|",
            "H:|-18-[title]-18-|",
            "V:[topTitle][title][subtitle]",
            "V:[more]-18-|"
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // remove for the update one
    public func setupForCurrency(currency: Currency, animated: Bool = true) {
        // TEMP
        let months = ["Jan", "Feb", "hkjh", "Mar"]
        let unitsSold = [10.0, 4.0, 4.0, 6.0]
        
        setupChart(months, values: unitsSold)
    }
    
}

extension DashboardChart: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfHoverRows(status: tableViewStatus)
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
    
    public func scrollToTop() {
        self.hoverTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    public func setupToWallet() {
        self.setTableViewStatus(newStatus: .wallet)
    }
    
    public func setupToCurrency() {
        self.setTableViewStatus(newStatus: .coin)
    }
    
    private func setTableViewStatus(newStatus: TableViewStatus ) {
        let oldCellNb = getNumberOfHoverRows(status: tableViewStatus)
        let newCellNb = getNumberOfHoverRows(status: newStatus)
        
        tableViewStatus = newStatus

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
    }
    
    private func getNumberOfHoverRows(status: TableViewStatus) -> Int {
        switch status {
        case .wallet:
            return 10
        default:
            return 2
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = HOVER_LABEL_BOTTOM - scrollView.contentOffset.y / 5
        let bottomMargin = diff > 18 ? diff : 18
        
        hoverLabelBottomConstraint?.constant = -bottomMargin
        chartContainerBottomConstraint?.constant = -scrollView.contentOffset.y
        
        self.contentView.layoutIfNeeded()
        
        if (scrollView.contentOffset.y < CHART_WIDTH_OFFSET_CONSTANT * 1.5) {
            chartWidthConstraint?.constant = CHART_WIDTH_OFFSET_CONSTANT - scrollView.contentOffset.y / 3
            
//            delegate?.changeTheme(.dark)
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: TITLE_SIZE - scrollView.contentOffset.y / 40)
            self.contentView.layoutIfNeeded()
            
            self.chartContainerSmallWidthConstraint?.isActive = false
            self.chartContainerFullWidthConstraint?.isActive = true
            UIView.animate(withDuration: K.Design.AnimationTime) {
                 self.moreLabel.alpha = 1
                self.contentView.layoutIfNeeded()
            }
        } else {
            delegate?.changeTheme(.clear)
            self.chartContainerFullWidthConstraint?.isActive = false
            self.chartContainerSmallWidthConstraint?.isActive = true
            UIView.animate(withDuration: K.Design.AnimationTime) {
                 self.moreLabel.alpha = 0
                self.contentView.layoutIfNeeded()
            }
        }
        // Chart animation
        if (scrollView.contentOffset.y < 0) {
//            chartView.leftAxis.axisMinimum = -10 + Double(abs(scrollView.contentOffset.y).squareRoot())
        } else {
//            chartView.leftAxis.axisMinimum = -10 - Double(scrollView.contentOffset.y)
        }
//
//        chartView.notifyDataSetChanged()
    }
    
    

    private func getHoverCellHeight() -> CGFloat {
        return hoverTableView.frame.height
    }


}

extension DashboardChart: ChartViewDelegate {

    private func setupChart(_ dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        dataEntries.append(ChartDataEntry(x: -1, y: 10))
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        dataEntries.append(ChartDataEntry(x: 4, y: 6))
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
        chartDataSet.lineCapType = .round
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 0
        //        chartDataSet.setColor(Color.custom(hexString: "#FFFFFF").withAlpha(0.95))
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.setCircleColors(UIColor.white)
        chartDataSet.circleHoleColor = UIColor.gradients.purple.value.first
        chartDataSet.circleHoleRadius = 5
        let gradientColors = UIColor.gradients.purple.cgColors as CFArray
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

protocol DashboardChartDelegate {
    func changeTheme(_ type: ThemeStatus)
}
