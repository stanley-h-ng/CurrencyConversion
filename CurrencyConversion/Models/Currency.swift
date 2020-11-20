//
//  Currency.swift
//  CurrencyConversion
//
//  Created by Stanley NG on 20/11/2020.
//

import Foundation

class Currency: NSObject, NSCoding {
    
    struct Keys {
        static let Code = "Code"
        static let Name = "Name"
    }
    
    var code = ""
    var name = ""
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        
        code = coder.decodeObject(forKey: Keys.Code) as? String ?? ""
        name = coder.decodeObject(forKey: Keys.Name) as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(code, forKey: Keys.Code)
        coder.encode(name, forKey: Keys.Name)
    }
}
