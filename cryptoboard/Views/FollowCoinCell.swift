//
//  FollowCoinCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class FollowCoinCell: UITableViewCell {
    
    let followImage = UIImage(named: "heart", in: Bundle.main, compatibleWith: nil)
    
    var delegate: FollowCoinCellDelegate?
    var currency: Currency?
    
    lazy var leftLabel = UILabel()
    lazy var followButton = FollowButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), image: followImage)
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
        followButton.addTarget(self, action: #selector(handleFollowClick(_:)), for: .touchUpInside)
        
        bottomBorder.backgroundColor = UIColor.theme.borderClear.value
        selectionStyle = .none
        
        leftLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        leftLabel.textColor = UIColor.theme.textDark.value
        
        contentView.addSubviewsAutoConstraints([leftLabel, followButton, bottomBorder])
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            followButton.heightAnchor.constraint(equalToConstant: 50),
            followButton.widthAnchor.constraint(equalToConstant: 50),
            leftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            bottomBorder.leftAnchor.constraint(equalTo: leftLabel.leftAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: followButton.rightAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
    
    public func setup(currency: Currency, selected: Bool) {
        leftLabel.text = currency.name
        self.currency = currency
        
        if (selected) {
            followButton.select()
        } else {
            followButton.deselect()
        }
    }
    
    @objc private func handleFollowClick(_ sender: FollowButton) {
        if (sender.isSelected) {
            sender.deselect()
            if let safeCurrency = currency {
                delegate?.didUnselectButton(currency: safeCurrency)
            }
        } else {
            sender.select()
            if let safeCurrency = currency {
                delegate?.didSelectButton(currency: safeCurrency)
            }
        }
    }
    

}

protocol FollowCoinCellDelegate {
    
    func didSelectButton(currency: Currency)
    func didUnselectButton(currency: Currency)
    
    
}
