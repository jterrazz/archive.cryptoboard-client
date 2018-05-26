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
    
    case currenciesHistory(currenciesFrom: [String], currencyTo: String)
    case currenciesState(currenciesFrom: [String], currencyTo: String)
    
    private var method: HTTPMethod {
        switch self {
        case .currenciesHistory, .currenciesState:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .currenciesHistory:
            return "/data/histoday"
        case .currenciesState:
            return "/data/pricemulti"
        }
    }
    
    private var params: Parameters? {
        switch self {
        case .currenciesState(let from, let to), .currenciesHistory(let from, let to):
            return [K.APIParamsKeys.currencyFrom: from.joined(separator: ","), K.APIParamsKeys.currencyTo: to]
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
