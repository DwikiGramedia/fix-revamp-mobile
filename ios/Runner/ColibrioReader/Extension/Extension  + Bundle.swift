//
//  Extension  + Bundle.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//

import Foundation

extension Bundle {
    var apiKey:String? {
        infoDictionary?["API_KEY"] as? String
    }
    
    var apiSecret: String? {
        infoDictionary?["API_SECRET"] as? String
    }
}
