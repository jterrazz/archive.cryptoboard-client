//
//  Chart.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import Charts

extension LineChartView {
    
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
        
        let color = variation == .up ? UIColor.theme.green.value : UIColor.theme.red.value
        let gradient = [
            color.withAlphaComponent(0.6).cgColor,
            color.withAlphaComponent(0).cgColor,
        ]
        
        chartDataSet.fill = self.getFillGradient(colors: gradient)
        chartDataSet.setColor(color)
        
        let chartData = LineChartData(dataSet: chartDataSet)
        self.data = chartData
        
        self.isUserInteractionEnabled = false
        self.xAxis.enabled = false
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.chartDescription?.enabled = false
        self.noDataText = ""
        self.legend.enabled = false
        self.leftAxis.axisMinimum = -10
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
    var names: [String] = ["WEEK 1", "WEEK 2", "WEEK 3"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if (value < 0 || Int(value) >= names.count) {
            return ""
        } else {
            return String(describing: names[Int(value)])
        }
    }
}
