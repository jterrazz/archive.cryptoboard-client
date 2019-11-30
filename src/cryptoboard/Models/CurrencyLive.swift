//
//  CurrencyLive.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 11/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import UIKit

// Delete data when user change local currency or add cache keyx with currency

class CurrencyLive: Codable {
    
    var price: Double
    var volumeDay: Double
    var highDay: Double
    var lowDay: Double
    var variationDay: Double
    var variationDayPercent: Double
    var marketCap: Double
    var supply: Double
    var updateTime: Date
    
    init(price: Double, volumeDay: Double, highDay: Double, lowDay: Double, marketCap: Double, supply: Double, variationDay: Double, variationDayPercent: Double) {
        self.price = price
        self.volumeDay = volumeDay
        self.highDay = highDay
        self.lowDay = lowDay
        self.marketCap = marketCap
        self.supply = supply
        self.updateTime = Date()
        self.variationDayPercent = variationDayPercent
        self.variationDay = variationDay
    }
    
    
}

extension CurrencyLive {
    
    func getVariationDayColor() -> UIColor {
        return (variationDay > 0) ? UIColor.theme.green.value : UIColor.theme.red.value
    }
    
    
}
