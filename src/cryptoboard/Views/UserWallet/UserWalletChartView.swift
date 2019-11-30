//
//  UserWalletChartView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 14/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

// TODO Limit to 50 coins followed + add infinite scroll ?
// TODO Limit to 50 coins the max asked to currenctPriceAPI

class UserWalletChartView: UIView {
    
    lazy var titleLabel = UILabel()
    lazy var modifyButton = UIButton(type: .custom)
    lazy var chartView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.theme.border.value.cgColor
        self.layer.borderWidth = 1
        self.addShadow()
        self.layer.cornerRadius = K.Design.CornerRadius
        
        titleLabel.text = "Last week performance"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor.theme.textDark.value
        
        modifyButton.setTitle("dddddd", for: .normal)
        modifyButton.backgroundColor = UIColor.green
        
        chartView.backgroundColor = UIColor.gray
        
        self.addSubviewsAutoConstraints([titleLabel, modifyButton, chartView])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            modifyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            modifyButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            chartView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            chartView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55)
            ])
    }
    
    
}
