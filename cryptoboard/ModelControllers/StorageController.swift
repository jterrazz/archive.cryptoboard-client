//
//  StorageController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

// when the user change their CurrencyTo settings, we clean all Storage data
// so we don't need to store the currencyTo param

class StorageController {
    
    private let CURRENCY_PREFIX_KEY: String = "currency-storage-key-"
    private let CURRENCY_HISTORY_PREFIX_KEY: String = "currency-history-state-key-"
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // CURRENCY PRICE HISTORY
    public func retrieveCurrencyHistory(symbol: String, aggregate: UInt, points: UInt) -> [CurrencyPrice]? {
        if let data = userDefaults.data(forKey: CURRENCY_HISTORY_PREFIX_KEY + String(aggregate) + "-" + String(points)) {
            let currency = try? decoder.decode(Currency.self, from: data)
            
            return currency?.historyPrice
        }
        return nil
    }
    
    public func storeCurrencyHistory(symbol: String, prices: [CurrencyPrice], aggregate: UInt, points: UInt) {
        let currency = CurrencyController.getCurrencyBase(symbol: symbol)
        currency?.historyPrice = prices
        
        if let encoded = try? encoder.encode(currency) {
            userDefaults.set(encoded, forKey: CURRENCY_HISTORY_PREFIX_KEY + String(aggregate) + "-" + String(points))
        }
    }
    
    // CURRENCY STATE
    public func retrieveCurrencyState(symbol: String) -> Currency? {
        if let data = userDefaults.data(forKey: CURRENCY_PREFIX_KEY + symbol) {
            let currency = try? decoder.decode(Currency.self, from: data)
            
            return currency
        }
        return nil
    }
    
    public func storeCurrencyState(currency: Currency) {
        if let encoded = try? encoder.encode(currency) {
            userDefaults.set(encoded, forKey: CURRENCY_PREFIX_KEY + currency.diminutive)
        }
    }
    
    
}
