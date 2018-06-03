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
    
    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var updated: UILabel!
    @IBOutlet weak var marketCapData: UILabel!
    @IBOutlet weak var volumeData: UILabel!
    @IBOutlet weak var updatedData: UILabel!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.theme.bg.value
        bottomBorder.backgroundColor = UIColor.theme.border.value
        
        marketCap.textColor = UIColor.theme.textIntermediate.value
        volume.textColor = UIColor.theme.textIntermediate.value
        updated.textColor = UIColor.theme.textIntermediate.value
        marketCapData.textColor = UIColor.theme.textDark.value
        volumeData.textColor = UIColor.theme.textDark.value
        updatedData.textColor = UIColor.theme.textDark.value
    }
    
    
}
