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
        let inside = UIView()
        inside.translatesAutoresizingMaskIntoConstraints = false
        inside.backgroundColor = UIColor.white
        inside.addShadow()
        return inside
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        self.addSubview(insideView)
        
        let title = UILabel()
        title.text = "My wallet"
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.textColor = UIColor.theme.textDark.value
        title.translatesAutoresizingMaskIntoConstraints = false
        insideView.addSubview(title)
        
        let views: [String: Any] = [
            "title": title,
            "cell": insideView
        ]
        let constraints = [
            "V:|-16-[title]-16-|",
            "H:|-16-[title]-16-|",
            "V:|-5-[cell]-5-|",
            "H:|-5-[cell]-5-|"
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
