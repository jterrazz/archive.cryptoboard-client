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
        tableView.contentInset = UIEdgeInsets.init(top: 100, left: 0, bottom: 200, right: 0)

        return tableView
    }()
    
    var chartBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hoverTableView.delegate = self
        hoverTableView.dataSource = self
        
        contentView.addSubview(chartView)
        contentView.addSubview(hoverTableView)
        backgroundColor = UIColor.theme.bg.value
        
        chartBottomConstraint = chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        chartBottomConstraint?.isActive = true
        
        let views = [
            "chart": chartView,
            "hover": hoverTableView
        ]
        let constraints = [
            "H:|[hover]|",
            "H:|[chart]|",
            "V:|-150-[chart]",
            "V:|[hover]|"
        ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // remove for the update one
    public func setupForCurrency(currency: Currency, animated: Bool = true) {
        // TEMP
        let months = ["Jan", "Feb", "Mar"]
        let unitsSold = [10.0, 4.0, 6.0]
        
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
            return 5
        default:
            return 2
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Chart animation
//        if (scrollView.contentOffset.y < 0) {
//            chartView.leftAxis.axisMinimum = -10 + Double(abs(scrollView.contentOffset.y).squareRoot())
//        } else {
//            chartView.leftAxis.axisMinimum = -10 - Double(scrollView.contentOffset.y)
//        }
//
//        chartView.notifyDataSetChanged()
//        chartBottomConstraint
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let velocity = scrollView.panGestureRecognizer.velocity(in: self.view).y
//
//        if (!showingDetailedHover && velocity < 0) { // Scrolled up when hoverTableView is hidden
//            hoverTableView.scrollToRow(at: IndexPath.init(row: 1, section: 0), at: .top, animated: true)
//            showingDetailedHover = true
//        } else if (true) { // Scrolled down when hoverTableView is close to row 1 TODO!!
//            hoverTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//            showingDetailedHover = false
//        }
//    }
//
    private func getHoverCellHeight() -> CGFloat {
        return hoverTableView.frame.height - 100
    }


}

//class DashboardChart: UICollectionViewCell {
//
//    lazy var currentPriceLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 26)
//        label.text = "$ 02222222"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//
//lazy var chartView: LineChartView = {
//    let chartView = LineChartView()
//    chartView.translatesAutoresizingMaskIntoConstraints = false
//
//    return chartView
//}()
//

//
//
//    lazy var hotView: UIView = {
//        let hotView = UIView()
//        hotView.translatesAutoresizingMaskIntoConstraints = false
//
//        return hotView
//    }()
//
//}
//


extension DashboardChart: ChartViewDelegate {

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


}
