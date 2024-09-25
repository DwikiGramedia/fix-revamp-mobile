//
//  ReaderInteractor.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation

protocol ReaderInteractorInput{
    func postRecord(record:RecordReadingModel)
    func postPage(page: PageViewEpp)
    func postEppRecord(body:RecordParameterEpp)
}

protocol ReaderInteractorOutput{
    func getRecord(response:RecordResponse)
    func getMessage(error:String)
}

class ReaderInteractor{
    var worker:ReaderWorker
    var presenter:ReaderInteractorOutput
    init(worker:ReaderWorker,presenter:ReaderInteractorOutput) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension ReaderInteractor:ReaderInteractorInput{
    
    func postRecord(record: RecordReadingModel) {
        worker.sendRecord(body: record){ response in
            switch response {
            case .success(let success):
                if success.user_message != nil {
                    self.presenter.getRecord(response: success)
                } else {
                    self.presenter.getMessage(error: success.user_message  ?? "")
                }
            case .failure(let failure):
                self.presenter.getMessage(error: String(describing: failure))
            }
        }
    }
    func postEppRecord(body: RecordParameterEpp) {
        let dataValue = worker.valuePages() ?? []
        let valueRecord = RecordParameterEpp(pageviews: dataValue)
        
        worker.recordEpp(body: valueRecord){ result in
            switch result {
            case .success(let success):
                if success.user_message == nil || ((success.user_message?.isEmpty) == nil) {
                    BookManagerService().deleteAllAnalytic()
                    self.presenter.getRecord(response: success)
                } else {
                    self.presenter.getMessage(error: success.user_message  ?? "Error User")
                }
            case .failure(let failure):
                switch failure {
                case .noConnection :
                    self.presenter.getMessage(error: "Offline Mode")
                case .cantSendService :
                    self.presenter.getMessage(error: "Cant send analytic service")
                case .unknown :
                    self.presenter.getMessage(error: "Something Wrong")
                }
            }
        }
    }
    
    func postPage(page: PageViewEpp) {
        worker.save(page: page)
    }
    
}
