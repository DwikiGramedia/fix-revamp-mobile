//
//  PDFReaderPresenter.swift
//  SCOOP
//
//  Created by Gramedia on 16/01/23.
//

typealias PDFReaderPresenterInput = PDFReaderInteractorOutput

protocol PDFReaderPresenterOutput{
    func getRecord(response:RecordResponse)
    func getMessage(error:String)
}

class PDFReaderPresenter:PDFReaderPresenterInput{
    var viewController:PDFReaderPresenterOutput
    init(viewController: PDFReaderPresenterOutput) {
        self.viewController = viewController
    }
    func getRecord(response: RecordResponse) {
        self.viewController.getRecord(response: response)
    }
    
    func getMessage(error: String) {
        self.viewController.getMessage(error: error)
    }
    
}


