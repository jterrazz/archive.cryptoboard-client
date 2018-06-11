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
    @IBOutlet weak var containerProgress: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    
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
        containerProgress.backgroundColor = UIColor.theme.darkBgHover.value
        containerProgress.layer.cornerRadius = K.Design.CornerRadius
        symbolLabel.textColor = UIColor.theme.textOnDark.value
        symbolLabel.font = UIFont.systemFont(ofSize: 14)
        
        let progressGradient = [
            UIColor.theme.custom(hexString: "#feb692").value.cgColor,
            UIColor.theme.custom(hexString: "#ea5455").value.cgColor
        ]
        
        progressHour.setup(0.5, colors: progressGradient)
        progressDay.setup(0.2, colors: progressGradient)
        progressMonth.setup(0.2, colors: progressGradient)
    }
    

}
