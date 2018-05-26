//
//  CoinInfosCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinInfosCell: UITableViewCell {
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.textDark.value
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.textDark.value
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        rightLabel.textAlignment = .right
        
        let views = [
            "left": leftLabel,
            "right": rightLabel
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-16-[left]-16-[right]-16-|"])
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    
}
