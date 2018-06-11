//
//  CurrencyLive.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class CurrencyLive: Codable {
    
    var price: Double?
    var volumeDay: Double?
    var highDay: Double?
    var lowDay: Double?
    var marketCap: Double?
    var supply: Double?
    var updateTime: Date?
    
    init(price: Double, volumeDay: Double, highDay: Double, lowDay: Double, marketCap: Double, supply: Double) {
        self.price = price
        self.volumeDay = volumeDay
        self.highDay = highDay
        self.lowDay = lowDay
        self.marketCap = marketCap
        self.supply = supply
        self.updateTime = Date()
    }
    
    
}
