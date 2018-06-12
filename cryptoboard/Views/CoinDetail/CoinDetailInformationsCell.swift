//
//  CoinDetailInformationsCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CoinDetailInformationsCell: UITableViewCell {
    
    lazy var containerView = RoundedContainerView.init(0, corners: [])
    lazy var leftLabel = UILabel()
    lazy var rightLabel = UILabel()
    lazy var subLeftLabel = UILabel()
    lazy var subRightLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.modifyCorners(0, corners: .allCorners)
    }
    
    public func setup(leftText: String, subLeftText: String?, rightText: String, subRightText: String?, corners: UIRectCorner?) {
        if let safeCorners = corners {
            containerView.modifyCorners(K.Design.CornerRadius, corners: safeCorners)
        }
        
        leftLabel.text = leftText
        rightLabel.text = rightText
        
        if (subLeftText != nil) {
            subLeftLabel.text = subLeftText
            subRightLabel.text = subRightText
            
            containerView.addSubviewsAutoConstraints([subLeftLabel, subRightLabel])
            
            NSLayoutConstraint.activate([
                leftLabel.bottomAnchor.constraint(equalTo: subLeftLabel.topAnchor, constant: 4),
                subLeftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
                subLeftLabel.leftAnchor.constraint(equalTo: leftLabel.leftAnchor),
                subRightLabel.rightAnchor.constraint(equalTo: rightLabel.rightAnchor, constant: 0),
                subRightLabel.centerYAnchor.constraint(equalTo: subLeftLabel.centerYAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
                ])
        }
    }
    
    private func commonInit() {
        selectionStyle = .none
        containerView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.theme.grayBg.value
        
        [leftLabel, rightLabel].forEach { (label) in
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            label.textColor = UIColor.theme.textDark.value
        }
        [subRightLabel, subLeftLabel].forEach { (label) in
            label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        }
        subLeftLabel.textColor = UIColor.theme.textIntermediate.value
        subRightLabel.textColor = UIColor.theme.green.value
        
        contentView.addSubviewAutoConstraints(containerView)
        containerView.addSubviewsAutoConstraints([leftLabel, rightLabel])
        
        let views = [
            "c": containerView,
            "l": leftLabel,
            "r": rightLabel
            ]
        let constraints = [
            "H:|-8-[c]-8-|",
            "V:|[c]|",
            "H:|-16-[l][r]-16-|",
            ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            rightLabel.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
            ])
    }
    
    
}
