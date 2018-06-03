//
//  CardCoinCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CardCoinCell: UICollectionViewCell {
    
    lazy var container = UIView()
    lazy var chartView = LineChartView()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let months = ["Jan", "Feb", "hkjh", "Mar"]
        let unitsSold = [10.0, 4.0, 4.0, 6.0]
        
        chartView.setupInCellChart(months, values: unitsSold, variation: .up)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        container.backgroundColor = UIColor.white
        container.layer.masksToBounds = false
        container.layer.cornerRadius = K.Design.CornerRadius
        container.layer.shadowColor = UIColor.theme.shadow.value.cgColor
        container.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        container.layer.shadowRadius = 10
        container.layer.shadowOpacity = 0.15
        
        chartView.layer.masksToBounds = true
        chartView.layer.cornerRadius = K.Design.CornerRadius
        
        addSubviewAutoConstraints(container)
        container.addSubviewAutoConstraints(title)
        container.addSubviewAutoConstraints(chartView)
        
        let views = [
            "title": title,
            "chart": chartView,
            "c": container
        ]
        let constraints = [
            "H:|[title]|",
            "H:|[chart]|",
            "V:|[title]",
            "V:[chart(250)]|",
            "H:|-8-[c]-8-|",
            "V:|-8-[c]-20-|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    
}
