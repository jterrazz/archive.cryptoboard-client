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
    lazy var box = UIView()
    lazy var chartView = LineChartView()
    
//    lazy var title: UILabel = {
//        let label = UILabel()
//        label.text = "Bitcoin"
//        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.regular)
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let months = ["Jan", "Feb", "hkjh", "Mar"]
        let unitsSold = [10.0, 4.0, 4.0, 6.0]
        
        let gradient = [UIColor.theme.custom(hexString: "#fccf30").value.cgColor, UIColor.theme.custom(hexString: "#f55555").value.cgColor]
        chartView.setupCardChart(months, values: unitsSold, colors: gradient)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        box.backgroundColor = UIColor.white
        box.layer.cornerRadius = K.Design.CornerRadius
        
        container.backgroundColor = UIColor.white
        container.layer.masksToBounds = false
        container.layer.cornerRadius = K.Design.CornerRadius
        container.layer.shadowColor = UIColor.theme.shadow.value.cgColor
        container.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.15
        
//        chartView.backgroundColor = UIColor.theme.darkBg.value
        chartView.layer.masksToBounds = true
        chartView.layer.cornerRadius = K.Design.CornerRadius
        
        addSubviewAutoConstraints(container)
//        container.addSubviewAutoConstraints(title)
        container.addSubviewAutoConstraints(chartView)
        container.addSubviewAutoConstraints(box)
        
        let views = [
//            "title": title,
            "chart": chartView,
            "c": container,
            "box": box
        ]
        let constraints = [
            "H:|-16-[box]-16-|",
            "H:|[chart]|",
            "V:[box(100)]-(-16)-|",
            "V:|[chart]|",
            "H:|-8-[c]-8-|",
            "V:|-16-[c]-32-|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    
}
