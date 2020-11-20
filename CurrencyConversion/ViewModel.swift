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
    var currencyText = BehaviorRelay<String>(value: "")
    
    var currencySelected: Currency?
    
    func start() {
        CurrencyService.shared.getCurrencies { [weak self] (currencies) in
            self?.currencies.accept(currencies)
        } failure: { (error) in
        }
    }
    
    func currencyDidSelect(index: Int) {
        if index < currencies.value.count {
            currencySelected = currencies.value[index]
            if let currencySelected = currencySelected {
                currencyText.accept("\(currencySelected.code) - \(currencySelected.name)")
            } else {
                currencyText.accept("")
            }
        }
    }
    
}
