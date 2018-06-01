//
//  MenuContentSell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class MenuContentCell: UITableViewCell {
    
    lazy var titleView: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.theme.textDark.value
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    lazy var border: UIView = {
        let border = UIView.init(frame: CGRect.zero)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.theme.border.value
        
        return border
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        contentView.addSubview(titleView)
        contentView.addSubview(border)
        
        let views = ["title": titleView, "border": border]
        let cs = border.heightAnchor.constraint(equalToConstant: 1)
        cs.priority = UILayoutPriority.init(999)
        cs.isActive = true
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-18-[title]-18-|", "V:|-14-[title]-14-[border]-0-|", "H:|[border]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(title: String) {
        titleView.text = title
    }
    
    
}
