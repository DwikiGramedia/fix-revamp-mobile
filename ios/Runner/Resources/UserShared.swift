//
//  UserShared.swift
//  Runner
//
//  Created by Chondro Satrio Wibowo on 04/01/24.
//

import Foundation

class UserShared {
    func getBool(forKey:String)-> Bool {
        return UserDefaults.standard.bool(forKey: forKey)
    }
    
    func getString(forKey:String)-> String {
        return UserDefaults.standard.string(forKey: forKey) ?? ""
    }
    
    func getInt(forKey:String) -> Int {
        return UserDefaults.standard.integer(forKey: forKey)
    }
}
