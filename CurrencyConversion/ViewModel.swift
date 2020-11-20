//
//  ViewModel.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation

class ViewModel {
    
    func start() {
        CurrencyService.shared.getCurrencies { (data) in
            
        } failure: { (error) in
            
        }

    }
    
}
