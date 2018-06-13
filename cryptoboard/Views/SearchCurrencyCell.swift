//
//  SearchCurrencyCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class SearchCurrencyCell: UITableViewCell {
    
    var currency: Currency? {
        didSet {
            showData()
        }
    }
    
    lazy var title: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.theme.textDark.value
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subtitle: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.theme.textIntermediate.value
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var addButton: UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.theme.blueClear.value.cgColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.theme.blueClear.value, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        button.setAttributedTitle(NSAttributedString(string: "Add", attributes: attributes), for: .normal)
        
        return button
    }()
    
    lazy var logo: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.green
        
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(addButton)
        contentView.addSubview(logo)
        
        let views = [
            "title": title,
            "subtitle": subtitle,
            "btn": addButton,
            "logo": logo
        ]
        let cs = logo.heightAnchor.constraint(equalToConstant: 38)
        cs.priority = UILayoutPriority.init(999)
        
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-[logo(38)]-[title]-[btn(64)]-|", "V:|-8-[logo]-8-|"])
        NSLayoutConstraint.activate([
            subtitle.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 0.9),
            title.topAnchor.constraint(equalTo: logo.topAnchor),
            subtitle.bottomAnchor.constraint(equalTo: logo.bottomAnchor),
            addButton.centerYAnchor.constraint(equalTo: logo.centerYAnchor),
            cs
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(currency: Currency) {
        self.currency = currency
    }
    
    private func showData() {
        title.text = currency?.diminutive
        subtitle.text = currency?.name
    }
}
