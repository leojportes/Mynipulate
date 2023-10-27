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

    public static func set(value: Bool, forString key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func set(value: String, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }

    public static func set(model: UserModel?, forKey key: Keys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            defaults.set(encoded, forKey: key.rawValue)
            defaults.synchronize()
        }
    }

    public static func setRequestData(model: RequestData?, forKey key: Keys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            // Verifique se já existe uma lista armazenada em UserDefaults
            if let existingData = defaults.data(forKey: key.rawValue) {
                var requestDataList = try? JSONDecoder().decode([RequestData].self, from: existingData)
                requestDataList?.append(model ?? .init(statusCode: -1, url: "optional nil"))
                if let updatedData = try? JSONEncoder().encode(requestDataList) {
                    defaults.set(updatedData, forKey: key.rawValue)
                }
            } else {
                // Se não existe uma lista, crie uma nova lista com o objeto atual
                let requestDataList: [RequestData] = [model ?? .init(statusCode: -1, url: "optional nil")]
                if let updatedData = try? JSONEncoder().encode(requestDataList) {
                    defaults.set(updatedData, forKey: key.rawValue)
                }
            }
            defaults.synchronize()
        }
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

    public static func get(boolForString: String) -> Bool? {
        if checkExistenceKey(key: boolForString) == false {
            return nil
        }
        return defaults.bool(forKey: boolForString)
    }
    
    public static func get(stringForKey: String) -> String? {
        if checkExistenceKey(key: stringForKey) == false {
            return nil
        }
        return defaults.string(forKey: stringForKey)
    }

    public static func get(modelForKey: Keys) -> UserModel? {
        if checkExistenceKey(key: modelForKey.rawValue) == false {
            return nil
        }
        guard let data = defaults.object(forKey: modelForKey.rawValue) as? Data else { return nil }
        let items = try? JSONDecoder().decode(UserModel.self, from: data)
        return items
    }

//    public static func getRequestData(model: Keys) -> RequestData? {
//        if checkExistenceKey(key: model.rawValue) == false {
//            return nil
//        }
//        guard let data = defaults.object(forKey: model.rawValue) as? Data else { return nil }
//        let items = try? JSONDecoder().decode(RequestData.self, from: data)
//        return items
//    }
    public static func getRequestDataList(forKey key: Keys) -> [RequestData]? {
        if let existingData = defaults.data(forKey: key.rawValue) {
            if let requestDataList = try? JSONDecoder().decode([RequestData].self, from: existingData) {
                return requestDataList
            }
        }
        return nil
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
        case authenticated = "authenticated"
        case nameAppleID = "nameAppleID"
        case passedTheOnboarding = "passedTheOnboarding"
        case loginWithApple = "loginWithApple"
        case rateApp = "rateApp"
        case currentUser = "currentUser"
        case requestData = "requestData"
    }
}
