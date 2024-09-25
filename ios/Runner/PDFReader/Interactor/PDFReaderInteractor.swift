//
//  PDFReaderInteractor.swift
//  SCOOP
//
//  Created by Gramedia on 16/01/23.
//

import Foundation

protocol PDFReaderInteractorInput{
    func postRecord(record:RecordReadingModel)
    func postEppRecord(body:RecordParameterEpp)
}

protocol PDFReaderInteractorOutput{
    func getRecord(response:RecordResponse)
    func getMessage(error:String)
}

class PDFReaderInteractor{
    var worker:PDFReaderWorker
    var presenter:PDFReaderInteractorOutput
    init(worker:PDFReaderWorker,presenter:PDFReaderInteractorOutput) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension PDFReaderInteractor:PDFReaderInteractorInput{
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
        worker.recordEpp(body: body)
    }
    
}

