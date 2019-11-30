//
//  Chart.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import Charts

// TODO Make a clean code

extension LineChartView {
    
    private func createEntries(values: [Double], withMargins: Bool = false) -> [ChartDataEntry] {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        if (withMargins) {
            dataEntries.insert(ChartDataEntry(x: -1, y: 10), at: 0)
            dataEntries.append(ChartDataEntry(x: 4, y: 6))
        }
        
        return dataEntries
    }
    
    func setupFilled(values: [Double], colors: [CGColor], withMargins: Bool = false) {
        let dataEntries = createEntries(values: values, withMargins: withMargins)
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
        
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 0
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.setCircleColors(UIColor.white)
        chartDataSet.circleHoleColor = colors.first != nil ? UIColor.init(cgColor: colors.first!) : UIColor.white
        chartDataSet.circleHoleRadius = 5
        
        chartDataSet.fill = self.getFillGradient(colors: colors)
        chartDataSet.fillAlpha = 1
        chartDataSet.circleRadius = 7
        
        let chartData = LineChartData(dataSet: chartDataSet)
        self.minOffset = 0
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        self.xAxis.labelTextColor = UIColor.theme.textOnDark.value
        self.xAxis.valueFormatter = HomeChartStringFormatter()
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.granularity = 1
        self.isUserInteractionEnabled = false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.chartDescription?.enabled = false
        self.noDataText = ""
        self.legend.enabled = false
        self.data = chartData
        self.leftAxis.axisMinimum = -10
    }
    
    func setupSimpleLine(_ dataPoints: [String], values: [Double], color: UIColor, withMargins: Bool = false) {
        let dataEntries = createEntries(values: values)
        let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        
        chartDataSet.lineWidth = 2
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.colors = [color]
        
        let chartData = LineChartData(dataSet: chartDataSet)
        
        self.minOffset = 0
        self.xAxis.enabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.granularity = 1
        self.isUserInteractionEnabled = false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.chartDescription?.enabled = false
        self.noDataText = ""
        self.legend.enabled = false
        self.data = chartData
    }
    
    func setupCardChart(_ dataPoints: [String], values: [Double], colors: [CGColor]) {
        var dataEntries: [ChartDataEntry] = []
        dataEntries.append(ChartDataEntry(x: -1, y: 10))
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        dataEntries.append(ChartDataEntry(x: 4, y: 6))
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 0
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.fill = self.getFillGradient(colors: colors)
        chartDataSet.fillAlpha = 1
        
        let chartData = LineChartData(dataSet: chartDataSet)
        
        self.minOffset = 0
        
        self.xAxis.enabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.granularity = 1
        self.isUserInteractionEnabled = false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.chartDescription?.enabled = false
        self.noDataText = ""
        self.legend.enabled = false
        self.data = chartData
        self.leftAxis.axisMinimum = -10 // TODO Crete dynamic ft
    }
    
    func setupInCellChart(_ dataPoints: [String], values: [Double], variation: ChartVariation) {
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
        chartDataSet.lineWidth = 1
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 1
        chartDataSet.drawCirclesEnabled = false
        
        let greenGradient = [
            UIColor.theme.custom(hexString: "#28c76f").withAlpha(0.5).cgColor,
            UIColor.theme.custom(hexString: "#81fbb8").withAlpha(0).cgColor,
        ]
        let redGradient = [
            UIColor.theme.custom(hexString: "#28c76f").withAlpha(0.5).cgColor,
            UIColor.theme.custom(hexString: "#81fbb8").withAlpha(0).cgColor,
        ]
        let gradient = [
            UIColor(white: 1, alpha: 0.5).cgColor,
            UIColor(white: 1, alpha: 0).cgColor
        ]
//        let gradient = variation == .up ? greenGradient : redGradient
        
        chartDataSet.fill = self.getFillGradient(colors: gradient)
        chartDataSet.setColor(UIColor.white)
        
        let chartData = LineChartData(dataSet: chartDataSet)
        self.data = chartData
        
        self.isUserInteractionEnabled = false
        self.xAxis.enabled = false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.chartDescription?.enabled = false
        self.noDataText = ""
        self.legend.enabled = false
        self.leftAxis.axisMinimum = -2
        self.minOffset = 0
    }
    
    func getFillGradient(colors: [CGColor], angle: CGFloat = 90) -> Fill {
        let gradientColors = colors as CFArray
        let colorLocations: [CGFloat] = [1, 0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        
        return Fill.fillWithLinearGradient(gradient!, angle: angle)
    }
    
    
}

class HomeChartStringFormatter: IAxisValueFormatter {
    var names: [String] = ["04", "05", "06", "07", "08"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if (value < 0 || Int(value) >= names.count) {
            return ""
        } else {
            return String(describing: names[Int(value)])
        }
    }
}
