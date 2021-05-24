//
//  Defaults.swift
//  Trackine
//
//  Created by Dayton on 21/04/21.
//

import Foundation

@propertyWrapper
struct Defaults<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
            
            // Convert data to the desired datatype
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to Data
            let data = try? JSONEncoder().encode(newValue)
            // Set value to to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}


