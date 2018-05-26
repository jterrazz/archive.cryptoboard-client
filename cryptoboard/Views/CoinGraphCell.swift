//
//  CoinGraphCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinGraphCell: UITableViewCell {
    
    lazy var chartView: UIView = {
        let chart = UIView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = UIColor.theme.custom(hexString: "#212121").value
        return chart
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(chartView)
        
        let views = [
            "chart": chartView
        ]
        let constraints = [
            "H:|[chart]|",
            "V:|[chart]|"
        ]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
