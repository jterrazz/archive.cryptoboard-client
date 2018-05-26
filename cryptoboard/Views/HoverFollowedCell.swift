//
//  HoverFollowedCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 23/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class HoverFollowedCell: UITableViewCell {
    
    var currency: Currency? {
        didSet {
            currencyName.text = currency?.name
        }
    }
    
    lazy var currencyName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "dddddd"
        label.textColor = UIColor.theme.textDark.value
        
        return label
    }()
    
    lazy var currencySubtitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dddddd"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.theme.textIntermediate.value
        
        return label
    }()
    
    lazy var currencyHoldings: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dddddd"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.theme.textIntermediate.value
        
        return label
    }()
    
    lazy var currencyQuantity: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dddddd"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.theme.textIntermediate.value
        
        return label
    }()
    
    lazy var currencyLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.red
        return imageView
    }()
    
    lazy var cell: UIView = {
        let cell = UIView()
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = K.Design.CornerRadius
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        contentView.addSubview(cell)
        cell.addSubview(currencyName)
        cell.addSubview(currencyLogo)
        cell.addSubview(currencySubtitle)
        cell.addSubview(currencyHoldings)
        cell.addSubview(currencyQuantity)
        
        let views = [
            "logo": currencyLogo,
            "name": currencyName,
            "qt": currencyQuantity,
            "hold": currencyHoldings,
            "sub": currencySubtitle,
            "cell": cell
        ]
        let constraints = [
            "H:|-16-[cell]-16-|",
            "V:|[cell]-8-|",
            "H:|-16-[logo(40)]-16-[name]",
            "H:[hold]-16-|",
            "V:|-8-[logo(40)]",
            "V:|-8-[name]-[sub]-8-|",
        ]
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: constraints)
        NSLayoutConstraint.activate([
            currencySubtitle.leftAnchor.constraint(equalTo: currencyName.leftAnchor),
            currencyQuantity.rightAnchor.constraint(equalTo: currencyHoldings.rightAnchor),
            currencyHoldings.topAnchor.constraint(equalTo: currencyName.topAnchor),
            currencyQuantity.topAnchor.constraint(equalTo: currencySubtitle.topAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
