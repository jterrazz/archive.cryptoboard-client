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
    
    public static func getList(limit: Int, callback: @escaping ([Currency]) -> Void) {
        
        let storageController = StorageController()
        var needUpdate = true
        
        if let cachedCurrencies = storageController.retrieveCurrencyList() {
            let dateLimit = cachedCurrencies.updatedAt.addingTimeInterval(K.APIValidity.currencyList)
            let now = Date()
            
            needUpdate = now > dateLimit
            callback(Array(cachedCurrencies.list.prefix(limit)))
        }
        needUpdate = true
        
        if (needUpdate) {
            APIClient.getCurrencyList { (updatedCurrencies) in
                let sortedCurrencies = updatedCurrencies.sorted(by: { $0.id <= $1.id })
                callback(Array(sortedCurrencies.prefix(limit)))
                storageController.storeCurrencyList(list: sortedCurrencies)
            }
        }
    }
    
    public static func getCurrencyState(currencies: [Currency], callback: @escaping ([Currency]) -> Void) {
        
        let storageController = StorageController()
        var toUpdate = [Currency]()
        var cachedCurrencies = [Currency]()
        var updatedCurrencies = [Currency]()
        let userSettingsController = UserSettingsController()
        let userLocalCurrency = userSettingsController.get()?.localCurrency
        
        if (userLocalCurrency == nil) {
           return
        }
        
        // Check the update
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
        
        var retCurrencies = mergeCurrencyArray(full: currencies, newArray: cachedCurrencies)
        callback(retCurrencies)
        
        // 2: Return updated data
        if (toUpdate.count > 0) {
            
            APIClient.getCurrenciesState(currenciesFrom: Currency.convertToSymbolArray(arr: toUpdate), currencyTo: userLocalCurrency!.rawValue) { (updatedCurrencyDictionary) in
                
                toUpdate.forEach({ (toUpdateBase) in
                    if let liveData = updatedCurrencyDictionary[toUpdateBase.diminutive] {
                        toUpdateBase.liveData = liveData
                        updatedCurrencies.append(toUpdateBase)
                    }
                })
                
                retCurrencies = mergeCurrencyArray(full: retCurrencies, newArray: updatedCurrencies)
                callback(retCurrencies)
                
                // 3: Cache data
                for currency in updatedCurrencies {
                    storageController.storeCurrencyState(currency: currency)
                }
            }
        }
    }
    
    private static func mergeCurrencyArray(full: [Currency], newArray: [Currency]) -> [Currency] {
        var ret = [Currency]()
        
        ret.append(contentsOf: newArray)
        
        for old in full {
            var alreadyInArray = false
            
            for retEl in ret {
                if (retEl.diminutive == old.diminutive) {
                    alreadyInArray = true
                }
            }
            
            if (!alreadyInArray) {
                ret.append(old)
            }
        }
        
        return ret
    }
    
    public static func getCurrencyBase(symbol: String, callback: @escaping (Currency?) -> Void) {
        
        var retCurrency: Currency? = nil
        
        // Search static base else search online
        for (currency): (Currency) in K.Currencies {
            if (currency.diminutive == symbol) {
                retCurrency = currency
            }
        }
        
        callback(retCurrency)
    }
    
    public static func getCurrenciesBase(symbols: [String], callback: @escaping ([Currency]) -> Void) {
        
        let taskGroup = DispatchGroup()
        var retCurrencies = [Currency]()
        
        symbols.forEach { (symbol) in
            taskGroup.enter()
            getCurrencyBase(symbol: symbol, callback: { (base) in
                if let safeBase = base {
                    retCurrencies.append(safeBase)
                }
                defer {
                    taskGroup.leave()
                }
            })
        }
        
        // TODO Put back in order if callback mess up order
        taskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            callback(retCurrencies)
        }))
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
