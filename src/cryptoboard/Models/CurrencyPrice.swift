//
//  CurrencyPrice.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class CurrencyPrice: Codable, CustomStringConvertible {
    
    var timestamp: Int64
    var price: Double
    var volume: Double
    
    var description: String {
        return "Timestamp: \(timestamp), price: \(price), volume: \(volume)"
    }
    
    init(price: Double, volume: Double, timestamp: Int64) {
        self.timestamp = timestamp
        self.price = price
        self.volume = volume
    }
    
    
}
