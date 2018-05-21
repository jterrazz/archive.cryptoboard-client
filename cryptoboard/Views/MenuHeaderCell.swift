//
//  MenuSectionCell.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 21/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class MenuHeaderCell: UIView {
    
    convenience init(text: String?, width: Int, height: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        if (text != nil) {
            let label = UILabel(frame: CGRect(x: 15, y: 9, width: width - 30, height: height))
            label.font = UIFont.boldSystemFont(ofSize: 11)
            label.textColor = UIColor.theme.textIntermediate.value
            label.text = text
            self.addSubview(label)
        }
        self.backgroundColor = UIColor.theme.bg.value
    }
    
    
}
