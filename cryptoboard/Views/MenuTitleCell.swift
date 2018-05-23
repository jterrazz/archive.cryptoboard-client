//
//  MenuTitleCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class MenuTitleCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        label.textColor = UIColor.theme.textDark.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.visualConstraints(views: ["title": titleLabel], visualConstraints: ["V:|-[title]-|", "H:[title]-|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(title: String) {
        titleLabel.text = title
    }
    
    
}
