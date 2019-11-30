//
//  CardCoinInformationsCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 13/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class CardCoinInformationsCell: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var variationLabel: UILabel!
    @IBOutlet var exploreLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardCoinInformationsCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = K.Design.CornerRadius
        
        [nameLabel, priceLabel, variationLabel, exploreLabel].forEach { (label) in
            label?.textColor = UIColor.theme.textDark.value
        }
        symbolLabel.textColor = UIColor.theme.textIntermediate.value
    }
    
    func setup(currency: Currency) {
        nameLabel.text = currency.name
        variationLabel.text = "+24%"
        symbolLabel.text = currency.diminutive
        if let price = currency.liveData?.price {
            priceLabel.text = String(price)
        }
    }
    
}
