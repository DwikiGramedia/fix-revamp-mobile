//
//  RecordParameterEpp.swift
//  Runner
//
//  Created by Gramedia on 09/01/23.
//

import Foundation

struct RecordParameterEpp:Encodable{
    var pageviews:[PageViewEpp]
}

struct PageViewEpp:Encodable{
    var borrowing_id:Int
    var item_id:Int
    var page_orientation:String
    var duration:Double
    var max_duration:Double
    var online_status:String
    var page_number:[Int]
    var chapter:String
    var start_time:String
    var end_time:String
    var device_id:String
    var device_model:String
    var os_version:String
    var client_version:String
    var client_id:Int
    var ip_address:String
    var datetime:String
    var user_id:Int
    var session_name:String
    var catalog_id:Int
    var organization_id:Int
}
