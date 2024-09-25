//
//  PDFReaderWorker.swift
//  SCOOP
//
//  Created by Gramedia on 16/01/23.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PDFReaderMainScene{
    func sendRecord(body:RecordReadingModel,callback:@escaping(Result<RecordResponse,AFError>)->Void)
    func recordEpp(body:RecordParameterEpp)
}

class PDFReaderWorker:PDFReaderMainScene{
    func sendRecord(body: RecordReadingModel, callback: @escaping (Result<RecordResponse, Alamofire.AFError>) -> Void) {
        let token = UserDefaults.standard.value(forKey: "token") as! String
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
    
    func recordEpp(body: RecordParameterEpp) {
        let token = UserDefaults.standard.string(forKey: "token")!
        let headers = HTTPHeaders(["Authorization":"\(token)"])


        AF.request("https://ebooks.gramedia.com/api/analytics",method: .post,parameters: body,encoder:JSONParameterEncoder.default,headers: headers).responseDecodable(of:RecordResponse.self){ response in
            //callback(response.result)
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
    
    

}
