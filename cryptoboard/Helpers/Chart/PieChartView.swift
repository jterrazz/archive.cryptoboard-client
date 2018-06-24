//
//  PieChartView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 05/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit
import Charts

// TODO Make clean code

extension PieChartView {
    
    func setupForVariation(_ variation: Double) {
        let isNeg = variation < 0
        let rightEntryLength = isNeg ? 1 - abs(variation) : abs(variation)
        let leftEntryLength = isNeg ? abs(variation) : 1 - abs(variation)
        var entries = [ChartDataEntry]()
        
        entries.append(ChartDataEntry(x: 0, y: rightEntryLength))
        entries.append(ChartDataEntry(x: 1, y: leftEntryLength))
        
        let chartData = PieChartData()
        let dataSet = PieChartDataSet.init(values: entries, label: nil)
        let variationColor = variation > 0 ? UIColor.theme.green.value : UIColor.theme.red.value
        let bgColor = UIColor.theme.custom(hexString: "#FFFFFF").withAlpha(0.15)
        
        dataSet.selectionShift = 0
        dataSet.colors = isNeg ? [bgColor, variationColor] : [variationColor, bgColor]
        dataSet.drawValuesEnabled = false
        chartData.addDataSet(dataSet)
        
        self.legend.enabled = false
        self.chartDescription?.enabled = false
        self.drawSlicesUnderHoleEnabled = false
        self.holeRadiusPercent = 0.9
        self.holeColor = UIColor.clear
        self.data = chartData
    }
    
    
}
