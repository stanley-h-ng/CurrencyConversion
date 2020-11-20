//
//  Config.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation

class Config {
    
    static let shared = Config()
    
    func currencyServiceHostname() -> String {
        return "api.currencylayer.com"
    }
    
    func currencyServiceBaseURL() -> String {
        return "http://\(currencyServiceHostname())"
    }
    
    func apiKey() -> String {
        return "034f9a53938e918a340c1be8ce5c71e7"
    }
    
    func refreshIntevalInSeconds() -> Double {
        return 30 * 60
    }
    
}
