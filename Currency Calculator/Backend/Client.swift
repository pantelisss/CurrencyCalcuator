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

}
