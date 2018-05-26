//
//  HoverEmptyCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 25/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class HoverEmptyCell: UITableViewCell {
    
    lazy var marginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.addSubview(marginView)
        NSLayoutConstraint.visualConstraints(views: ["v0": marginView], visualConstraints: ["V:|[v0]|", "H:|[v0]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(height: CGFloat) {
        marginView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    
}
