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

// TODO Handle all errors
// TODO Make the dispatch.main here and not in views

class CurrencyController {
    
    let storageController = StorageController()
    let userSettingsController = UserSettingsController()
    
    func getList(limit: Int, callback: @escaping (Error?, [Currency]) -> Void) {
        
        var needUpdate = true
        
        if let cachedCurrencies = storageController.retrieveCurrencyList() {
            let dateLimit = cachedCurrencies.updatedAt.addingTimeInterval(K.APIValidity.currencyList)
            let now = Date()
            
            needUpdate = now > dateLimit
            needUpdate = true // TODO remove
            if (!needUpdate) {
                return callback(nil, Array(cachedCurrencies.list.prefix(limit)))
            }
        }
        
        if (needUpdate) {
            APIClient.getCurrencyList { (error, updatedCurrencies) in
                if (error != nil) {
                    return callback(APIError.connectionError, [])
                }
                let sortedCurrencies = updatedCurrencies.sorted(by: { $0.id <= $1.id })
                
                do {
                    try self.storageController.storeCurrencyList(list: sortedCurrencies)
                    callback(nil, Array(sortedCurrencies.prefix(limit)))
                } catch {
                    callback(StorageError.saveError, [])
                }
            }
        }
    }
    
    func getCurrencyState(currencies: [Currency], callback: @escaping (Error?, [Currency]) -> Void) {
        
        var toUpdate = [Currency]()
        var cachedCurrencies = [Currency]()
        var updatedCurrencies = [Currency]()
        let userLocalCurrency = userSettingsController.get()?.localCurrency
        
        if (userLocalCurrency == nil) {
           return
        }
        
        // TODO Check this is working as expected
        currencies.forEach { (currency) in
            let dateLimit = currency.liveData?.updateTime.addingTimeInterval(20)
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
        callback(nil, retCurrencies)
        
        // 2: Return updated data
        if (toUpdate.count > 0) {
            
            // TODO Handle errors
            APIClient.getCurrenciesState(currenciesFrom: Currency.convertToSymbolArray(arr: toUpdate), currencyTo: userLocalCurrency!.rawValue) { (updatedCurrencyDictionary) in
                
                toUpdate.forEach({ (toUpdateBase) in
                    if let liveData = updatedCurrencyDictionary[toUpdateBase.diminutive] {
                        toUpdateBase.liveData = liveData
                        updatedCurrencies.append(toUpdateBase)
                    }
                })
                
                retCurrencies = self.mergeCurrencyArray(full: retCurrencies, newArray: updatedCurrencies)
                callback(nil, retCurrencies)
                
                // 3: Cache data
                for currency in updatedCurrencies {
                    self.storageController.storeCurrencyState(currency: currency)
                }
            }
        }
    }
    
    // Transfert in Currency.swift
    func mergeCurrencyArray(full: [Currency], newArray: [Currency]) -> [Currency] {
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
    
    // TODO Use cache + add error handling
    func getCurrencyBase(symbol: String, callback: @escaping (Error?, Currency?) -> Void) {
        
        var retCurrency: Currency? = nil
        
        // Search hardcoded db else search online
        // TODO: Maybe remove for only online data ?
        for (currency): (Currency) in K.Currencies {
            if (currency.diminutive == symbol) {
                retCurrency = currency
            }
        }
        
        if (retCurrency != nil) {
            callback(nil, retCurrency)
        } else {
            self.getList(limit: 99999) { (error, currencies) in
                // TODO Handle error
                
                for (currency): (Currency) in currencies {
                    if (currency.diminutive == symbol) {
                        retCurrency = currency
                        break
                    }
                }
                
                callback(nil, retCurrency)
            }
        }
    }
    
    func getCurrenciesBase(symbols: [String], callback: @escaping (Error?, [Currency]) -> Void) {
        
        let taskGroup = DispatchGroup()
        var retCurrencies = [Currency]()
        
        symbols.forEach { (symbol) in
            taskGroup.enter()
            getCurrencyBase(symbol: symbol, callback: { (error, base) in
                // TODO handle error
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
            // TODO Handle error
            callback(nil, retCurrencies)
        }))
    }
    
    func getCurrencyHistory(_ type: CurrencyHistoryType, currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt, callback: @escaping (Error?, [CurrencyPrice]) -> Void) {
        
        let prices = storageController.retrieveCurrencyHistory(symbol: currencyFrom, aggregate: aggregate, points: points)
        if let safePrices = prices {
            // TODO handle error
            callback(nil, safePrices)
        }
        
        APIClient.getCurrencyHistory(type, currencyFrom: currencyFrom, currencyTo: currencyTo, aggregate: aggregate, points: points) { (newPrices) in
            callback(nil, newPrices)
            
            // TODO handle error
            self.storageController.storeCurrencyHistory(symbol: currencyFrom, prices: newPrices, aggregate: aggregate, points: points)
        }
    }
    
    
}
