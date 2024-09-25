//
//  DownloadManager.swift
//  Runner
//
//  Created by Gramedia on 19/12/22.
//

import Foundation
import Alamofire

class DownloadManager{
    var progress:Double = 0.0
    var metaKeyData:GetMetakey?
    var download:DownloadRequest?
    
    func download(id:Int,token:String,callback:@escaping(Result<URL,AFError>)->Void){
        let progressQueue = DispatchQueue(label:"com.alamofire.progressQueue",qos:.utility)
        let fileTemporary = FileManager.default.temporaryDirectory.appendingPathComponent("\(id)").appendingPathComponent("\(id).zip")

        let destination: DownloadRequest.Destination = {_,_ in
            return (fileTemporary,[.removePreviousFile, .createIntermediateDirectories])
        }
        let header = HTTPHeaders(["Authorization":"\(token)"])
         download = AF.download("https://scoopadm.apps-foundry.com/scoopcor/api/v1/items/\(id)/download",headers: header, to: destination).downloadProgress(queue: progressQueue,closure: {progress in
             DispatchQueue.main.async{
                 print(progress.fractionCompleted)
                 self.progress = progress.fractionCompleted
             }
        }).responseURL{ response in
            
            print(response.error)
            callback(response.result)
        }
    }
    
    func cancelDownload(){
        download?.cancel()
    }
    
}
