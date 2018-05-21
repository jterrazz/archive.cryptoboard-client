//
//  HoverWalletCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 19/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class HoverWalletCell: UITableViewCell {
    
    lazy var insideView: UIView = {
        let inside = UIView(frame: CGRect.zero)
        inside.translatesAutoresizingMaskIntoConstraints = false
        inside.backgroundColor = UIColor.white
        inside.layer.cornerRadius = K.Design.CornerRadius
        inside.addShadow()
        return inside
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        self.addSubview(insideView)
        
        let title = UILabel()
        title.text = "My wallet"
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.textColor = UIColor.theme.textDark.value
        title.translatesAutoresizingMaskIntoConstraints = false
        insideView.addSubview(title)
        
        var constraints: [NSLayoutConstraint] = []
        let views: [String: Any] = [
            "title": title,
        ]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[title]-16-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[title]-16-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setupConstraints(topMargin: CGFloat) {
        var constraints: [NSLayoutConstraint] = []
        let views: [String: Any] = [
            "cell": insideView,
        ]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(topMargin)-[cell]-16-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[cell]-16-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    
}
