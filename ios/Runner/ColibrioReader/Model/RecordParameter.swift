//
//  RecordParameter.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation

// MARK: - RecordReadingModel
struct RecordReadingModel: Codable {
    let pageviews: [Pageview]
}

// MARK: - Pageview
struct Pageview: Codable {
    let duration: Double
    let itemID, maxDuration: Int
    let onlineStatus: String
    let pageNumber: [Int]
    let pageOrientation: String
    let clientID: Int
    let clientVersion, datetime, deviceID, deviceModel: String
    let osVersion, sessionName: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case duration
        case itemID = "item_id"
        case maxDuration = "max_duration"
        case onlineStatus = "online_status"
        case pageNumber = "page_number"
        case pageOrientation = "page_orientation"
        case clientID = "client_id"
        case clientVersion = "client_version"
        case datetime
        case deviceID = "device_id"
        case deviceModel = "device_model"
        case osVersion = "os_version"
        case sessionName = "session_name"
        case userID = "user_id"
    }
}
