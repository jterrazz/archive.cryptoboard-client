//
//  FollowCoinCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class FollowCoinCell: UITableViewCell {
    
    lazy var leftLabel = UILabel()
    lazy var followButton = UIButton()
    lazy var bottomBorder = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        bottomBorder.backgroundColor = UIColor.theme.borderClear.value
        selectionStyle = .none
        
        leftLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        leftLabel.textColor = UIColor.theme.textDark.value
        
        contentView.addSubviewsAutoConstraints([leftLabel, followButton, bottomBorder])
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            leftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            bottomBorder.leftAnchor.constraint(equalTo: leftLabel.leftAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: followButton.rightAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
    
    public func setup(name: String, image: UIImage?, followed: Bool) {
        leftLabel.text = name
    }
    

}
