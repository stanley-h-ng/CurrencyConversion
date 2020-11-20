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
        static let ConversionRatesLateUpdateTime = "ConversionRatesLateUpdateTime"
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
    
    func store(conversionRatesLateUpdateTime: Date) {
        let data = NSKeyedArchiver.archivedData(withRootObject: conversionRatesLateUpdateTime)
        writeToFile(data: data, filename: Filenames.ConversionRatesLateUpdateTime)
    }
    
    func fetchConversionRatesLateUpdateTime() -> Date? {
        if let data = readFile(filename: Filenames.ConversionRatesLateUpdateTime) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Date
        }
        return nil
    }
}
