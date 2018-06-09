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
    lazy var hoverInformations = CoinDetailChartDataView()
    lazy var chartSegmentedControll = RoundSegmentedControl(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let gradient = [
            UIColor.theme.custom(hexString: "#abdcff").value.cgColor,
            UIColor.theme.custom(hexString: "#0296ff").value.cgColor,
        ]
        
        backgroundColor = UIColor.theme.darkBg.value
        chartSegmentedControll.borderColor = UIColor.init(white: 1, alpha: 0.5)
        chartView.setupFilled(values: [4, 5, 1, 6, 4, 9], colors: gradient, withMargins: true)
        addSubviewsAutoConstraints([chartView, hoverInformations, chartSegmentedControll])
        
        let views = [
            "chart": chartView,
            "infos": hoverInformations
        ]
        let constraints = [
            "H:|-48-[infos]|",
            "H:|[chart]|",
            "V:[infos]-32-[chart]|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            hoverInformations.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0),
            chartSegmentedControll.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
            chartSegmentedControll.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -24),
            chartSegmentedControll.heightAnchor.constraint(equalToConstant: 36),
            chartSegmentedControll.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
}
