//
//  Defaults.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class StorageManager {
    private let userDefaults: UserDefaults
    
    static let defaults = StorageManager()
    
    private init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func retrieve() -> Month {
        let encoded = self.userDefaults.object(forKey: Key.month.rawValue) as! Data
        do {
            let savedMonth = try PropertyListDecoder().decode(Month.self, from: encoded)
            return savedMonth
        }
        catch {
            print("Can't find it")
            self.save(value: [Week(), Week(), Week(), Week()])
            return self.retrieve()
        }
    }
    
    func save(value: Month) {
        do {
            let encodedValue = try PropertyListEncoder().encode(value)
            self.userDefaults.set(encodedValue, forKey: Key.month.rawValue)
            print("saved")
        }
        catch {
            print("can't save it")
        }
    }
}
