//
//  PDFReaderConfigurator.swift
//  SCOOP
//
//  Created by Gramedia on 16/01/23.
//

import Foundation

enum PDFReaderConfigurator{
    static func configurator(viewController:PDFReaderView){
        let presenter = PDFReaderPresenter(viewController: viewController)
        let worker = PDFReaderWorker()
        let interactor = PDFReaderInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
    }
}

