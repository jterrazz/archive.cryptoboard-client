//
//  WalletView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 05/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

class WalletView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circleChartView: PieChartView!
    @IBOutlet weak var mainChartView: LineChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WalletView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = K.Design.CornerRadius
        contentView.backgroundColor = UIColor.white
        
        setupMainChart()
        circleChartView.setupForVariation(0.4)
    }
    
    private func setupMainChart() {
        let months = ["Jan", "Feb", "hkjh", "Mar"]
        let unitsSold = [10.0, 4.0, 4.0, 6.0]
        
        mainChartView.setupSimpleLine(months, values: unitsSold, color: UIColor.theme.custom(hexString: "#abdcff").value)
    }
    
    
}
