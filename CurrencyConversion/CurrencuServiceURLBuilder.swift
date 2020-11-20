//
//  CurrencuServiceURLBuilder.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation

class CurrencyServiceURLBuilder {
    
    private struct EndPoints {
        static let CurrencyList = "/list"
        static let ConversionRates = "/live"
    }
    
    static func currencyListURL() -> String {
        return "\(Config.shared.currencyServiceBaseURL())\(EndPoints.CurrencyList)"
    }
    
    static func conversionRatesURL() -> String {
        return "\(Config.shared.currencyServiceBaseURL())\(EndPoints.ConversionRates)"
    }
    
}
