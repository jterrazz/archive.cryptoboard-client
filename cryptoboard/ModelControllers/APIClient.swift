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
    
    static func getCurrenciesHistory(currenciesFrom: [String], currencyTo: String, callback: @escaping ([Currency]) -> Void) {
        Alamofire.request(APIRouter.currenciesHistory(currenciesFrom: currenciesFrom, currencyTo: currencyTo)).responseJSON { (response) in
            guard response.error == nil else {
                return
            }
            
            var currencies = [Currency]()
            
            if (response.result.value != nil) {
                let json = JSON(response.result.value!)
                
                if let data = json["Data"].array {
                    for (currencyData): (JSON) in data {
                        if let time = currencyData["time"].int, let open = currencyData["open"].double { // TODO
//                            currencies.append(Currency(id: <#T##UInt#>, name: <#T##String#>, diminutive: <#T##String#>, imageName: <#T##String?#>))
                        } else {
                            
                        }
                    }
                    callback(currencies)
                }
            }
        }
    }
    
    static func getCurrenciesState(currenciesFrom: [String], currencyTo: String, callback: @escaping ([Currency]) -> Void) {
        Alamofire.request(APIRouter.currenciesState(currenciesFrom: currenciesFrom, currencyTo: currencyTo)).responseJSON { (response) in
            guard response.error == nil else {
                return
            }
            
            //            let json = JSON(response.result.value)
            //            var error = false
            //            var prices: [String: Double]
            //
            //            currenciesFrom.forEach({ (currency) in
            //                guard let price = json[currency]
            //            })
            //            if let json[
        }
    }
}
