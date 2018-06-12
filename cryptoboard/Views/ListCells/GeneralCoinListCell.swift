//
//  GeneralCoinListCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 03/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

class GeneralCoinListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var updated: UILabel!
    @IBOutlet weak var marketCapData: UILabel!
    @IBOutlet weak var volumeData: UILabel!
    @IBOutlet weak var updatedData: UILabel!
    @IBOutlet weak var marketBorder: UIView!
    @IBOutlet weak var volumeBorder: UIView!
    @IBOutlet weak var updateBorder: UIView!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = K.Design.CornerRadius
        containerView.backgroundColor = UIColor.theme.darkBgHover.value
        
        for (index, borderView) in [marketBorder, volumeBorder, updateBorder].enumerated() {
            borderView?.layer.cornerRadius = 3
            
            // TODO Change gradient per index
            borderView?.applyGradient(colours: [
                UIColor.theme.custom(hexString: "#29fadf").value,
                UIColor.theme.custom(hexString: "#4c83ff").value,
                ])
        }
        
        for label in [marketCap, updated, volume] {
            label?.textColor = UIColor.theme.textOnDark.value
        }
    }
    
    
}
