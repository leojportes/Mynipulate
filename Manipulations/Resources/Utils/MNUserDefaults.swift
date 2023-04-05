//
//  UserDefaultsMN.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

public class MNUserDefaults {
    private static let defaults = UserDefaults.standard
    
    // MARK: Check
    public static func checkExistenceKey(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    // MARK: Set
    public static func set(value: Bool, forKey key: Keys) {
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    public static func set(value: String, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func set(value: Int, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    // MARK: - Get
    public static func get(intForKey: String) -> Int? {
        if checkExistenceKey(key: intForKey) == false {
            return nil
        }
        return defaults.integer(forKey: intForKey)
    }
    
    public static func get(boolForKey: Keys) -> Bool? {
        if checkExistenceKey(key: boolForKey.rawValue) == false {
            return nil
        }
        return defaults.bool(forKey: boolForKey.rawValue)
    }
    
    public static func get(stringForKey: String) -> String? {
        if checkExistenceKey(key: stringForKey) == false {
            return nil
        }
        return defaults.string(forKey: stringForKey)
    }
    
    // MARK: - Remove
    public static func remove(key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
}

extension MNUserDefaults {
    
    public enum Keys: String {
        case contributorMode = "contributor_mode"
    }
}
