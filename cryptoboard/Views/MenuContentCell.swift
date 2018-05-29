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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let border = UIView.init(frame: CGRect.zero)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = UIColor.theme.border.value
        
        backgroundColor = UIColor.white
        contentView.addSubview(titleView)
        contentView.addSubview(border)
        
        let views = ["title": titleView, "border": border]
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-18-[title]-18-|", "V:|-14-[title]-14-[border(1)]-0-|", "H:|[border]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(title: String) {
        titleView.text = title
    }
    
    
}
