//
//  CoinListCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 25/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CoinListCell: UITableViewCell {
    
    lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "btc")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.text = "BTC"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.textDark.value
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.text = "$ 433"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.textDark.value
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    lazy var variation: UILabel = {
       let label = UILabel()
        label.text = "+20%"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.green
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    lazy var chart: LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = UIColor.red
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    
    lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.theme.border.value
        
        return separator
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(logo)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(chart)
        contentView.addSubview(variation)
        contentView.addSubview(separator)
        
        let views = [
            "logo": logo,
            "name": name,
            "price": price,
            "chart": chart,
            "var": variation,
            "separator": separator
        ]
        let cs = logo.heightAnchor.constraint(equalToConstant: 36)
        
        cs.priority = UILayoutPriority.init(999)
        NSLayoutConstraint.visualConstraints(views: views, visualConstraints: ["H:|-18-[logo(36)]-[name]-9-[var(<=80)]-9-[chart(90)]-18-|", "V:|-20-[logo]-20-[separator(1)]|", "H:|[separator]|"])
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: logo.topAnchor),
            price.topAnchor.constraint(equalTo: name.bottomAnchor),
            price.leftAnchor.constraint(equalTo: name.leftAnchor),
            variation.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chart.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chart.heightAnchor.constraint(equalToConstant: 40),
            cs
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
