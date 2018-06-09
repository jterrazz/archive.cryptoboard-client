//
//  CoinDetailChartDataView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 06/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class CoinDetailChartDataView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressHour: ProgressView!
    @IBOutlet weak var progressDay: ProgressView!
    @IBOutlet weak var progressMonth: ProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CoinDetailChartDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.clear
        
        let progressGradient = [
            UIColor.theme.custom(hexString: "#feb692").value.cgColor,
            UIColor.theme.custom(hexString: "#ea5455").value.cgColor
        ]
        
        progressHour.setup(0.5, colors: progressGradient)
        progressDay.setup(0.2, colors: progressGradient)
        progressMonth.setup(0.2, colors: progressGradient)
    }
    

}
