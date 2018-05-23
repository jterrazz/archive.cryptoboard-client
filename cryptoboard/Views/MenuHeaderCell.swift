//
//  MenuSectionCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textColor = UIColor.theme.textIntermediate.value

        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let border = UIView.init(frame: CGRect.zero)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.theme.border.value

        contentView.backgroundColor = UIColor.theme.bg.value
        contentView.addSubview(titleLabel)
        contentView.addSubview(border)
        
        let views = ["title": titleLabel, "border": border]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-18-[title]-18-|", "V:|-18-[title]-9-[border(1)]-0-|", "H:|[border]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(title: String) {
        titleLabel.text = title
    }
    
    
}
