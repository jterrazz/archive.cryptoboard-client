//
//  CurrencyList.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class CurrencyList: Codable {
    
    var list: [Currency]
    var updatedAt: Date
    
    init(list: [Currency]) {
        self.list = list
        self.updatedAt = Date()
    }
    
    
}
