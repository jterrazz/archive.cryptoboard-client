//
//  CurrencyController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation

// triggers a first time the callback from cached data
// update the data if needed

class CurrencyController {
    
    public static func getCurrencyState(currencies: [Currency], callback: @escaping ([Currency]) -> Void) {
        
        let storageController = StorageController()
        var toUpdate = [Currency]()
        var cachedCurrencies = [Currency]()
        var updatedCurrencies = [Currency]()
        
        currencies.forEach { (currency) in
            let dateLimit = currency.liveData?.updateTime?.addingTimeInterval(20)
            let now = Date()
            
            if (dateLimit == nil || now > dateLimit!) {
                toUpdate.append(currency)
            } else {
                
            }
        }
        
        // 1: Return cached data
        for currency in currencies {
            if let newCurrency = storageController.retrieveCurrencyState(symbol: currency.diminutive) {
                cachedCurrencies.append(newCurrency)
            }
        }
        callback(cachedCurrencies)
        
        // 2: Return updated data
        if (toUpdate.count > 0) {
            APIClient.getCurrenciesState(currenciesFrom: Currency.convertToSymbolArray(arr: toUpdate), currencyTo: "USD") { (updatedDictionary) in
                for (symbol, currencyLiveData): (String, CurrencyLive) in updatedDictionary {
                    if let currency = getCurrencyBase(symbol: symbol) {
                        currency.liveData = currencyLiveData
                        updatedCurrencies.append(currency)
                    }
                }
                
                callback(updatedCurrencies)
            }
        }
        
        // 3: Cache data
        for currency in updatedCurrencies {
            storageController.storeCurrencyState(currency: currency)
        }
    }
    
    public static func getCurrencyBase(symbol: String) -> Currency? {
        
        var retCurrency: Currency? = nil
        
        // Search static base else search online
        for (currency): (Currency) in K.Currencies {
            if (currency.diminutive == symbol) {
                retCurrency = currency
            }
        }
        
        return retCurrency
    }
    
    public static func getCurrencyHistory(_ type: CurrencyHistoryType, currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt, callback: @escaping ([CurrencyPrice]) -> Void) {
        let storageController = StorageController()
        
        let prices = storageController.retrieveCurrencyHistory(symbol: currencyFrom, aggregate: aggregate, points: points)
        if let safePrices = prices {
            callback(safePrices)
        }
        APIClient.getCurrencyHistory(type, currencyFrom: currencyFrom, currencyTo: currencyTo, aggregate: aggregate, points: points) { (newPrices) in
            callback(newPrices)
            
            storageController.storeCurrencyHistory(symbol: currencyFrom, prices: newPrices, aggregate: aggregate, points: points)
        }
    }
    
    
}
