//
//  Currency.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class Currency {
    
    var id: UInt
    var name: String
    var diminutive: String
    var imageName: String?
    
    init(id: UInt, name: String, diminutive: String, imageName: String?) {
        self.id = id
        self.name = name
        self.diminutive = diminutive
        self.imageName = imageName != nil ? imageName : "\(diminutive)_icon"
    }
    
    
}
