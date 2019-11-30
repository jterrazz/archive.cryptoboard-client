//
//  UnderWalletView.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 04/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class UnderWalletView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var coinsCell: UIView!
    @IBOutlet weak var settingsCell: UIView!
    @IBOutlet weak var settingsImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UnderWalletView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        coinsCell.layer.cornerRadius = K.Design.CornerRadius
        settingsCell.layer.cornerRadius = K.Design.CornerRadius
        
        let settingsImage = UIImage.init(named: "settings")?.withRenderingMode(.alwaysTemplate)
        settingsImageView.image = settingsImage
        settingsImageView.tintColor = UIColor.white
    }

    
}
