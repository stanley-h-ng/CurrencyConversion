//
//  CurrencyService.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation
import Alamofire

class CurrencyService {
    
    static let shared = CurrencyService()
    
    let TimeoutInSeconds = 30
    
    let session: Session!
    
    init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = TimeInterval(TimeoutInSeconds)
        
        let serverTrustManager = ServerTrustManager(evaluators: [Config.shared.currencyServiceHostname(): DisabledTrustEvaluator()])
        
        session = Session(configuration: urlSessionConfiguration, serverTrustManager: serverTrustManager)
    }
    
    private func request(url: String,
                         parameters: Parameters,
                         completion: @escaping (NSDictionary) -> Void,
                         failure: @escaping (Error?) -> Void) {
        
        session.request(url, parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let data = data as? NSDictionary {
                        completion(data)
                    } else {
                        failure(nil)
                    }
                } else {
                    failure(nil)
                }
            case .failure(_):
                failure(nil)
            }
        }
    }
    
    func getCurrencies(completion: @escaping ([Currency]) -> Void, failure: @escaping (Error?) -> Void) {
        if let lastUpdate = LocalStorageManager.shared.fetchCurrencyListLastUpdateTime(),
           let currencyList = LocalStorageManager.shared.fetchCurrencyList() {
            
            if Date() < lastUpdate.addingTimeInterval(Config.shared.refreshIntevalInSeconds()) {
                completion(currencyList)
                return
            }
        }
        
        let url = CurrencyServiceURLBuilder.currencyListURL()
        let parameters = [
            "access_key": Config.shared.apiKey()
        ]
        
        request(url: url, parameters: parameters) { (data) in
            if data["success"] as? Bool == true {
                var result: [Currency] = []
                if let currencies = data["currencies"] as? [String: String] {
                    let keys = currencies.keys.sorted()
                    for key in keys {
                        if let name = currencies[key] {
                            result.append(Currency(code: key, name: name))
                        }
                    }
                }
                LocalStorageManager.shared.store(currencyList: result)
                LocalStorageManager.shared.store(currencyListLastUpdateTime: Date())
                completion(result)
            } else {
                failure(nil)
            }
        } failure: { (error) in
            failure(nil)
        }
    }
    
    func getConversionRates(completion: @escaping ([String: Double]) -> Void, failure: @escaping (Error?) -> Void) {
        if let lastUpdate = LocalStorageManager.shared.fetchConversionRatesLastUpdateTime(),
           let conversionRates = LocalStorageManager.shared.fetchConversionRates() {
            
            if Date() < lastUpdate.addingTimeInterval(Config.shared.refreshIntevalInSeconds()) {
                completion(conversionRates)
                return
            }
        }
        
        let url = CurrencyServiceURLBuilder.conversionRatesURL()
        let parameters = [
            "access_key": Config.shared.apiKey()
        ]
        
        request(url: url, parameters: parameters) { (data) in
            if data["success"] as? Bool == true {
                if let conversionRates = data["quotes"] as? [String: Double] {
                    LocalStorageManager.shared.store(conversionRates: conversionRates)
                    LocalStorageManager.shared.store(conversionRatesLastUpdateTime: Date())
                    completion(conversionRates)
                }
            } else {
                failure(nil)
            }
        } failure: { (error) in
            failure(nil)
        }

    }
    
}
