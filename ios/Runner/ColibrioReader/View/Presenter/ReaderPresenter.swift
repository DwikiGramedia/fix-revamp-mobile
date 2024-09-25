//
//  ReaderPresenter.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation

typealias ReaderPresenterInput = ReaderInteractorOutput

protocol ReaderPresenterOutput{
    func getRecord(response:RecordResponse)
    func getMessage(error:String)
}

class ReaderPresenter:ReaderPresenterInput{
    var viewController:ReaderPresenterOutput
    init(viewController: ReaderPresenterOutput) {
        self.viewController = viewController
    }
    func getRecord(response: RecordResponse) {
        self.viewController.getRecord(response: response)
    }
    
    func getMessage(error: String) {
        self.viewController.getMessage(error: error)
    }
    
    
}
