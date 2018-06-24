//
//  APIRouter.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 26/05/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case currenciesState(currenciesFrom: [String], currencyTo: String)
    case histoDay(currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt)
    case histoHour(currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt)
    case histoMinute(currencyFrom: String, currencyTo: String, aggregate: UInt, points: UInt)
    case currencyList()
    
    private var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .histoDay:
            return "/data/histoday"
        case .histoHour:
            return "/data/histohour"
        case .histoMinute:
            return "/data/histominute"
        case .currenciesState:
            return "/data/pricemultifull"
        case .currencyList:
            return "/data/all/coinlist"
        }
    }
    
    private var params: Parameters? {
        switch self {
        case .currenciesState(let from, let to):
            return [K.APIParamsKeys.currenciesFrom: from.joined(separator: ","), K.APIParamsKeys.currenciesTo: to]
        case .histoDay(let from, let to, let aggregate, let points), .histoHour(let from, let to, let aggregate, let points), .histoMinute(let from, let to, let aggregate, let points):
            return [K.APIParamsKeys.currencyFrom: from, K.APIParamsKeys.currencyTo: to, K.APIParamsKeys.aggregate: aggregate, K.APIParamsKeys.limit: points]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try K.APIServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderFields.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderFields.contentType.rawValue)
        
        return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
    }
    
    
}
