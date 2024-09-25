//
//  ReaderWorker.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ReaderAnalyticError:Error{
    case noConnection
    case unknown
    case cantSendService
}

protocol ReaderMainScene{
    func sendRecord(body:RecordReadingModel,callback:@escaping(Result<RecordResponse,AFError>)->Void)
    
    func recordEpp(body:RecordParameterEpp,callback: @escaping((Result<RecordResponse, ReaderAnalyticError>)->Void))
}

class ReaderWorker:CoreDataBrain, ReaderMainScene{
    func sendRecord(body: RecordReadingModel, callback: @escaping (Result<RecordResponse, Alamofire.AFError>) -> Void) {
        let token = UserDefaults.standard.string(forKey: "token")!
        let headers = HTTPHeaders(["Authorization":"\(token)"])
        
        AF.request("https://ebooks.gramedia.com/api/analytics",method: .post,parameters: body,encoder:JSONParameterEncoder.default,headers: headers).responseDecodable(of:RecordResponse.self){ response in
            callback(response.result)
            print("Header >>> \(String(describing: headers))")
            print("URL Request >>> \(String(describing: response.request))")  // original URL request
            print("Status Code >>> \(String(describing: response.response?.statusCode))")
            
            if let data = response.data, let responseJson = try? JSON(data: data) {
                print(responseJson, "\n\n")
//                logIntoNetfox(header: String(describing: headers),
//                              urlRequest: String(describing: response.request),
//                              statusCode: String(describing: response.response?.statusCode),
//                              parameter: "",
//                              responseJSON: responseJson)
            }
            
        }
    }
    
    func recordEpp(body: RecordParameterEpp,callback: @escaping((Result<RecordResponse, ReaderAnalyticError>)->Void)) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let headers = HTTPHeaders(["Authorization":"\(token)"])
            AF.request("https://ebooks.gramedia.com/api/analytics",method: .post,parameters: body,encoder:JSONParameterEncoder.default,headers: headers).responseDecodable(of:RecordResponse.self){ response in
                //callback(response.result)
                print("Header >>> \(String(describing: headers))")
                print("URL Request >>> \(String(describing: response.request))")  // original URL request
                print("Status Code >>> \(String(describing: response.response?.statusCode))")
                switch response.result {
                case .success(let success):
                    if response.response?.statusCode == 201 {
                        callback(.success(success))
                    } else if NetworkMonitorObserver.isConnected == false {
                        callback(.failure(.noConnection))
                    } else {
                        callback(.failure(.cantSendService))
                    }
                    
                case .failure(_):
                    if NetworkMonitorObserver.isConnected == false {
                        callback(.failure(.noConnection))
                    } else {
                        callback(.failure(.unknown))
                    }
                }
                
                if let data = response.data, let responseJson = try? JSON(data: data) {
                    print(responseJson, "\n\n")
                }
                
            }
        }
        


       
    }
    let versionNumberString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    
    func valuePages()-> [PageViewEpp]?{
        let request = ReaderAnalytic.fetchRequest()
        do {
            var pageEpp:[PageViewEpp] = []
            let valueAnalytics = try CoreDataBrain().context.fetch(request)
            valueAnalytics.forEach{ value in
                let page = PageViewEpp(borrowing_id: Int(value.borrowedId), item_id: Int(value.itemId), page_orientation: value.pageOrientation ?? "", duration: value.duration, max_duration: value.duration, online_status: value.onlineStatus ?? "", page_number: value.pageNumber ?? [], chapter: "", start_time: value.dateTime ?? "", end_time: value.dateTime ?? "", device_id: UIDevice.deviceId(), device_model: UIDevice.current.model, os_version: UIDevice.current.systemVersion, client_version: value.clientVersion ?? "", client_id: Int(value.clientId), ip_address: "192.168.0.1", datetime: value.dateTime ?? "", user_id: Int(value.userId), session_name: "\(value.dateTime ?? "")\(String(describing: UIDevice.deviceId))".sha256(), catalog_id: Int(value.catalogId), organization_id: Int(value.organizationId))
                pageEpp.append(page)
            }
            return pageEpp
        } catch {
            return nil
        }
    }
    func save(page: PageViewEpp){
        print(page)
        var readerAnalytic = ReaderAnalytic(context: context)
        readerAnalytic.clientVersion = page.client_version
        readerAnalytic.itemId = Int32(page.item_id)
        readerAnalytic.clientVersion = versionNumberString ?? "3.0.4"
        readerAnalytic.pageNumber = page.page_number
        readerAnalytic.dateTime = page.datetime
        readerAnalytic.pageOrientation = page.page_orientation
        readerAnalytic.organizationId = Int32(page.organization_id)
        readerAnalytic.catalogId = Int32(page.user_id)
        readerAnalytic.userId = Int32(page.user_id)
        readerAnalytic.duration = page.duration
        readerAnalytic.clientId = Int32(page.client_id)
        readerAnalytic.onlineStatus = page.online_status
        print(readerAnalytic)
        saveData()
    }

}

