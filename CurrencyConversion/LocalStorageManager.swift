//
//  LocalStorageManager.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation

class LocalStorageManager {
    
    static let shared = LocalStorageManager()
    
    struct Filenames {
        static let ConversionRates = "ConversionRates"
        static let ConversionRatesLastUpdateTime = "ConversionRatesLastUpdateTime"
        static let CurrencyList = "CurrencyList"
        static let CurrencyListLastUpdateTime = "CurrencyListLastUpdateTime"
    }
    
    private var pathForCache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    private func writeToFile(data: Data, filename: String) {
        do {
            let filepath = pathForCache.appendingPathComponent(filename)
            try data.write(to: filepath, options: [.atomic])
        } catch {}
    }
    
    private func readFile(filename: String) -> Data? {
        do {
            let filepath = pathForCache.appendingPathComponent(filename)
            let data = try Data(contentsOf: filepath)
            return data
        } catch {}
        return nil
    }
    
    func store(conversionRates: [String: Double]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: conversionRates)
        writeToFile(data: data, filename: Filenames.ConversionRates)
    }
    
    func fetchConversionRates() -> [String: Double]? {
        if let data = readFile(filename: Filenames.ConversionRates) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Double]
        }
        return nil
    }
    
    func store(conversionRatesLastUpdateTime: Date) {
        let data = NSKeyedArchiver.archivedData(withRootObject: conversionRatesLastUpdateTime)
        writeToFile(data: data, filename: Filenames.ConversionRatesLastUpdateTime)
    }
    
    func fetchConversionRatesLastUpdateTime() -> Date? {
        if let data = readFile(filename: Filenames.ConversionRatesLastUpdateTime) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Date
        }
        return nil
    }
    
    func store(currencyList: [Currency]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: currencyList)
        writeToFile(data: data, filename: Filenames.CurrencyList)
    }
    
    func fetchCurrencyList() -> [Currency]? {
        if let data = readFile(filename: Filenames.CurrencyList) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Currency]
        }
        return nil
    }
    
    func store(currencyListLastUpdateTime: Date) {
        let data = NSKeyedArchiver.archivedData(withRootObject: currencyListLastUpdateTime)
        writeToFile(data: data, filename: Filenames.CurrencyListLastUpdateTime)
    }
    
    func fetchCurrencyListLastUpdateTime() -> Date? {
        if let data = readFile(filename: Filenames.CurrencyListLastUpdateTime) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Date
        }
        return nil
    }
}
