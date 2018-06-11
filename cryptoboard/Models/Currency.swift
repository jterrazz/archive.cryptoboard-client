//
//  Currency.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 22/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

class Currency: Codable, CustomStringConvertible {
    
    var id: UInt
    var name: String
    var diminutive: String
    var imageName: String?
    var liveData: CurrencyLive?
    var historyPrice: [CurrencyPrice]?
    var createdAt: Date
    
    var description: String {
        return "ID: \(id), name: \(name), diminutive: \(diminutive), imageName: \(String(describing: imageName)), liveData: \(String(describing: liveData))"
    }
    
    static func convertToSymbolArray(arr: [Currency]) -> [String] {
        var ret = [String]()
        
        arr.forEach { (currency) in
            ret.append(currency.diminutive)
        }
        
        return ret
    }
    
    init(id: UInt, name: String, diminutive: String, imageName: String?) {
        self.id = id
        self.name = name
        self.diminutive = diminutive
        self.imageName = imageName != nil ? imageName : "\(diminutive)_icon"
        self.createdAt = Date()
    }
    
    
}

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

class CurrencyList: Codable {
    
    var list: [Currency]
    var updatedAt: Date
    
    init(list: [Currency]) {
        self.list = list
        self.updatedAt = Date()
    }
    
    
}
