//
//  Client.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 03/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit
import Alamofire

fileprivate struct Constants {
    static let apiUrl = "https://api.fixer.io/latest"
}

enum ClientErrors: Error {
    case invalidResponse
    case responseError(code: Int)
}

class Client: NSObject {
    
    static let sharedInstance = Client()
    
    /// Retrieve available currencies
    ///
    /// - Parameter completion: A block which returns an array of available currency symbols (eg. "USD", "GBP" etc)
    /// - Returns: DataRequest, caller is able to cancel the pending request
    func getAvailableCurrencies(completion: @escaping (_ currencies: [String]?, _ error :Error?) -> Void) -> DataRequest? {
        return Alamofire.request(Constants.apiUrl, method: .get).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                debugPrint(error)
                completion(nil, error)
                return
            case .success:
                guard let json = response.result.value as? [String : Any] else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                guard let rates = json["rates"] as? [String : Any] else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                completion(Array(rates.keys), nil)
            }
        }
    }
    
    /// Get specific currencies and their values
    ///
    /// - Parameters:
    ///   - base: The base currency
    ///   - currencies: The requested currencies
    ///   - completion: A block which returns a dictionary with the requested currencies
    /// - Returns: DataRequest, caller is able to cancel the pending request
    func getCurrencies(base: String, currencies: [String], completion: @escaping (_ currencies: [String : Float]?, _ error :Error?) -> Void) -> DataRequest? {
        let params = ["symbols" : currencies]
        
        return Alamofire.request(Constants.apiUrl, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                debugPrint(error)
                completion(nil, error)
                return
            case .success:
                guard let json = response.result.value as? [String : Any] else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                guard let rates = json["rates"] as? [String : Float] else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                completion(rates, nil)
            }
        }
    }

    /// Get the exchange response from service
    ///
    /// - Parameters:
    ///   - base: The base currency
    ///   - completion: A block which returns an Exchange object
    /// - Returns: DataRequest, caller is able to cancel the pending request
    func getExchange(base: String?, completion: @escaping (_ currencies: Exchange?, _ error :Error?) -> Void) -> DataRequest? {
        var params: [String : Any]?
        if let b = base {
            params = ["base" : b]
        }
        
        return Alamofire.request(Constants.apiUrl, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                debugPrint(error)
                completion(nil, error)
                return
            case .success:
                guard let json = response.result.value as? [String : Any] else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                guard let exchange = Exchange(dict: json) else {
                    completion(nil, ClientErrors.invalidResponse)
                    return
                }
                
                completion(exchange, nil)
            }
        }
    }

}
