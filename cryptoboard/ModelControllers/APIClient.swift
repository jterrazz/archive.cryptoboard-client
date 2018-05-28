//
//  APIClient.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    
    static func getCurrencyHistory(_ type: CurrencyHistoryType, currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt, callback: @escaping ([CurrencyPrice]) -> Void) {
        let router: APIRouter
        
        switch type {
        case .day:
            router = APIRouter.histoDay(currencyFrom: currencyFrom, currencyTo: currencyTo, aggregate: aggregate, points: points)
        case .hour:
            router = APIRouter.histoHour(currencyFrom: currencyFrom, currencyTo: currencyTo, aggregate: aggregate, points: points)
        case .minute:
            router = APIRouter.histoMinute(currencyFrom: currencyFrom, currencyTo: currencyTo, aggregate: aggregate, points: points)
        }
        
        Alamofire.request(router).responseJSON { (response) in
            guard response.error == nil else {
                return
            }
            
            var ret = [CurrencyPrice]()
            
            if (response.result.value != nil) {
                let json = JSON(response.result.value!)
                
                if let prices = json["Data"].array {
                    for (priceObj) in prices {
                        if let price = priceObj["close"].double, let volume = priceObj["volumeto"].double, let time = priceObj["time"].int64 {
                            let newPrice = CurrencyPrice(price: price, volume: volume, timestamp: time)
                            
                            ret.append(newPrice)
                        }
                    }
                }
            }
            
            callback(ret)
        }
    }
    
    static func getCurrenciesState(currenciesFrom: [String], currencyTo: String, callback: @escaping ([String: CurrencyLive]) -> Void) {
        Alamofire.request(APIRouter.currenciesState(currenciesFrom: currenciesFrom, currencyTo: currencyTo)).responseJSON { (response) in
            guard response.error == nil else {
                return
            }
            
            var ret = [String: CurrencyLive]()
            
            if (response.result.value != nil) {
                let json = JSON(response.result.value!)
                
                if let dictionary = json["RAW"].dictionary {
                    for (symbol, toArr): (String, JSON) in dictionary {
                        let d = toArr[currencyTo]
                        
                        if let price = d["PRICE"].double, let volume = d["VOLUME24HOURTO"].double, let high = d["HIGHDAY"].double,
                            let low = d["LOWDAY"].double, let marketCap = d["MKTCAP"].double, let supply = d["SUPPLY"].double {
                            
                            ret[symbol] = CurrencyLive.init(price: price, volumeDay: volume, highDay: high, lowDay: low, marketCap: marketCap, supply: supply)
                        }
                    }
                }
            }
            
            callback(ret)
        }
    }
}
