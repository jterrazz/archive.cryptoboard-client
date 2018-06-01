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
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.theme.textIntermediate.value

        return label
    }()
    
    lazy var border: UIView = {
        let border = UIView.init(frame: CGRect.zero)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.theme.border.value
        
        return border
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.theme.bg.value
        contentView.addSubview(titleLabel)
        contentView.addSubview(border)
        
        let views = ["title": titleLabel, "border": border]
        let constraints = [
            border.heightAnchor.constraint(equalToConstant: 1),
            border.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18)
        ]
        constraints.forEach { (cs) in
            cs.priority = UILayoutPriority.init(999)
        }
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-18-[title]-18-|", "H:|[border]|"])
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(title: String) {
        titleLabel.text = title
    }
    
    
}
