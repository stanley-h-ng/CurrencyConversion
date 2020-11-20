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
    
    func getCurrencies(completion: @escaping ([Currency]) -> Void, failure: @escaping (Error?) -> Void) {
        let url = CurrencyServiceURLBuilder.currencyListURL()
        let parameters = [
            "access_key": Config.shared.apiKey()
        ]
        session.request(url, parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    if let data = data as? NSDictionary {
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
                            completion(result)
                        } else {
                            failure(nil)
                        }
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
    
}