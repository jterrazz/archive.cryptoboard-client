//
//  CoinWithChartHeader.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 10/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinWithChartHeader: UITableViewHeaderFooterView {
    
    lazy var containerView = RoundedContainerView(K.Design.CornerRadius, corners: [.topLeft, .topRight])
    lazy var graphLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var coinLabel = UILabel()
    lazy var borderView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let labels = [graphLabel, priceLabel, coinLabel]
        var constraints = [NSLayoutConstraint]()
        
        backgroundColor = UIColor.clear
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear
        borderView.backgroundColor = UIColor.theme.border.value
        containerView.backgroundColor = UIColor.theme.bg.value
        
        graphLabel.text = "1W Graph"
        priceLabel.text = "Price"
        coinLabel.text = "Coin"
        
        for label in labels {
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = UIColor.theme.textDark.value
            constraints.append(label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        }
        
        contentView.addSubviewsAutoConstraints([containerView, borderView])
        containerView.addSubviewsAutoConstraints(labels)
        NSLayoutConstraint.activate([
            graphLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            coinLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 110),
            priceLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            borderView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            borderView.heightAnchor.constraint(equalToConstant: 1),
            borderView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
