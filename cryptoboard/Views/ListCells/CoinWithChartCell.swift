//
//  CoinWithChartCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 10/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CoinWithChartCell: UITableViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var border: UIView!
    
    override func awakeFromNib() {
        setViews()
        setupChart()
    }
    
    private func setViews() {
        containerView.backgroundColor = UIColor.white
        backgroundColor = UIColor.theme.darkBg.value
        chartView.backgroundColor = UIColor.theme.darkBg.value
        chartView.layer.cornerRadius = 3
        chartView.isUserInteractionEnabled = false
        
        logoView.backgroundColor = UIColor.red
        
        chartView.layer.cornerRadius = 3
        chartView.clipsToBounds = true
        border.backgroundColor = UIColor.theme.border.value
        coinName.textColor = UIColor.theme.textDark.value
        coinPrice.textColor = UIColor.theme.textDark.value
        volumeLabel.textColor = UIColor.theme.textIntermediate.value
    }
    
    private func setupChart() {
        let months = ["Jan", "Feb", "hkjh", "Mar"]
        let unitsSold = [10.0, 4.0, 4.0, 6.0]
        
        chartView.setupInCellChart(months, values: unitsSold, variation: .up)
    }
    
    
}
