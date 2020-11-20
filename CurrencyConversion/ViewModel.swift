//
//  ViewModel.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation
import RxCocoa

class ViewModel {
    
    var currencies = BehaviorRelay<[Currency]>(value: [])
    
    func start() {
        CurrencyService.shared.getCurrencies { [weak self] (currencies) in
            self?.currencies.accept(currencies)
        } failure: { (error) in
        }
    }
    
}
