//
//  RecordedResponse.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation

// MARK: - RecordResponse
struct RecordResponse: Codable {
    let status:Int?
    let error_code:Int?
    let user_message:String?
    let developer_message:String?
    let recorded: Recorded?
   
}

// MARK: - Recorded
struct Recorded: Codable {
    let pageviews: Int?
}
