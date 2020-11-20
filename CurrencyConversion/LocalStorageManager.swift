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
        static let CurrencyRates = "CurrencyRates"
    }
    
    private var pathForCache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    private func writeToFile(data: Data, filename: String) {
        do {
            let filepath = pathForCache.appendingPathComponent(filename)
            try data.write(to: filepath, options: [.atomic])
        } catch {}
    }
    
    private func readFile(filename: String) -> Any? {
        do {
            let filepath = pathForCache.appendingPathComponent(filename)
            let data = try Data(contentsOf: filepath)
            if let anyObj = NSKeyedUnarchiver.unarchiveObject(with: data) {
                return anyObj
            }
        } catch {}
        return nil
    }
    
    func store(conversionRates: [String: Double]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: conversionRates)
        writeToFile(data: data, filename: Filenames.CurrencyRates)
    }
    
    func fetchConversionRates() -> [String: Double]? {
        return readFile(filename: Filenames.CurrencyRates) as? [String: Double]
    }
    
}
