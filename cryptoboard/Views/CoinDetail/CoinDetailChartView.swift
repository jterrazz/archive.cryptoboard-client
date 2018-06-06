//
//  CoinDetailView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 05/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CoinDetailChartView: UIView {
    
    lazy var chartView = LineChartView()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$20 000.00"
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var priceSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Current value"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var marketcapLabel: UILabel = {
        let label = UILabel()
        label.text = "$20 000.00"
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var marketcapSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Current value"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        backgroundColor = UIColor.theme.darkBg.value
        let gradient = [
            UIColor.theme.custom(hexString: "#abdcff").value.cgColor,
            UIColor.theme.custom(hexString: "#0296ff").value.cgColor,
        ]
        chartView.setupFilled(values: [4, 5, 1, 6, 4, 9], colors: gradient, withMargins: true)
        addSubviewsAutoConstraints([chartView, priceLabel, priceSubtitleLabel, marketcapLabel, marketcapSubtitleLabel])
        
        let views = [
            "chart": chartView,
            "price": priceLabel,
            "priceSub": priceSubtitleLabel,
            "mk": marketcapLabel,
            "mkSub": marketcapSubtitleLabel
        ]
        let constraints = [
            "H:|[chart]|",
            "H:|-16-[price]",
            "V:|-200-[chart]|",
            "V:[price]-2-[priceSub]-42-|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            priceSubtitleLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor),
            marketcapLabel.leftAnchor.constraint(greaterThanOrEqualTo: priceLabel.rightAnchor, constant: 16),
            marketcapLabel.leftAnchor.constraint(greaterThanOrEqualTo: priceSubtitleLabel.rightAnchor, constant: 16),
            marketcapSubtitleLabel.leftAnchor.constraint(equalTo: marketcapLabel.leftAnchor),
            marketcapSubtitleLabel.bottomAnchor.constraint(equalTo: priceSubtitleLabel.bottomAnchor),
            marketcapLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor)
        ])
        
    }
    
    
}
