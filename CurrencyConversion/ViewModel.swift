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
    var results = BehaviorRelay<[ResultCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var currencySelected: Currency?
    var amount = 0.0
    
    func start() {
        isLoading.accept(true)
        CurrencyService.shared.getCurrencies { [weak self] (currencies) in
            self?.isLoading.accept(false)
            self?.currencies.accept(currencies)
        } failure: { (error) in
            // TODO: Show Error
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
            calculateResults()
        }
    }
    
    func amountDidUpdate(amount: String) {
        self.amount = Double(amount) ?? 0
        calculateResults()
    }
    
    func calculateResults() {
        if let currencySelected = currencySelected, amount != 0 {
            CurrencyService.shared.getConversionRates { [weak self] conversionRates in
                if let self = self {
                    if let conversionRateToUSD = conversionRates["USD\(currencySelected.code)"] {
                        let amountInUSD = self.amount / conversionRateToUSD
                        var resultCellViewModels: [ResultCellViewModel] = []
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        
                        for curreny in self.currencies.value {
                            if let desiredConversionRate = conversionRates["USD\(curreny.code)"] {
                                let resultCellViewModel = ResultCellViewModel()
                                resultCellViewModel.currency = "\(curreny.code) - \(curreny.name)"
                                resultCellViewModel.amount = numberFormatter.string(from: amountInUSD * desiredConversionRate as NSNumber) ?? ""
                                resultCellViewModels.append(resultCellViewModel)
                            }
                        }
                        self.results.accept(resultCellViewModels)
                    } else {
                        // TODO: Show Error
                        self.results.accept([])
                    }
                }
            } failure: { [weak self] error in
                // TODO: Show Error
                self?.results.accept([])
            }
        } else {
            results.accept([])
        }
    }
}
