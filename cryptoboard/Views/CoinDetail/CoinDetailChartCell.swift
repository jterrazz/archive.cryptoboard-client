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

class CoinDetailChartCell: UITableViewCell {
    
    lazy var containerView = UIView()
    lazy var chartView = LineChartView()
    lazy var hoverInformations = CoinDetailChartDataView()
    lazy var chartSegmentedControll = RoundSegmentedControl(frame: .zero)
    
    var topContainerConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        chartSegmentedControll.borderColor = UIColor.init(white: 1, alpha: 0.5)
        chartView.setupFilled(values: [4, 5, 1, 6, 4, 9], colors: gradient, withMargins: true)
        addSubviewAutoConstraints(containerView)
        containerView.addSubviewsAutoConstraints([chartView, hoverInformations, chartSegmentedControll])
        
        topContainerConstraint = containerView.topAnchor.constraint(equalTo: safeTopAnchor)
        
        let views = [
            "c": containerView,
            "chart": chartView,
            "infos": hoverInformations
        ]
        let constraints = [
            "H:|[c]|",
            "V:[c]|",
            "H:|-48-[infos]|",
            "H:|[chart]|",
            "V:|[infos]-32-[chart]|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            chartSegmentedControll.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
            chartSegmentedControll.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -24),
            chartSegmentedControll.heightAnchor.constraint(equalToConstant: 36),
            chartSegmentedControll.widthAnchor.constraint(equalToConstant: 200),
            topContainerConstraint!
        ])
    }
    
    public func setOffset(offset: CGFloat, trigger: CGFloat) {
        if (offset < 0) {
            topContainerConstraint?.constant = offset / 3
            return
        } else if (offset < trigger) {
            topContainerConstraint?.constant = offset
        }
    }
    
    
}
