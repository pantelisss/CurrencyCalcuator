//
//  Exchange.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 05/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import Foundation

struct Exchange {
    let base: String
    let date: String
    let rates: [String : Float]
}

extension Exchange {
    init?(dict: [String : Any]) {
        guard let base = dict["base"] as? String else {return nil}
        guard let date = dict["date"] as? String else {return nil}
        guard let rates = dict["rates"] as? [String : Float] else {return nil}
        
        self.base = base
        self.date = date
        self.rates = rates
    }
    
    func getPrice(currency: String, amount: Float) -> Float {
        if currency == base {
            return amount
        }
        
        guard let price = rates[currency] else {return 0.0}
        
        return price * amount
    }
}
