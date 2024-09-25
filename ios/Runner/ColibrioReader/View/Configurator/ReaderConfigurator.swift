//
//  ReaderConfigurator.swift
//  Runner
//
//  Created by Gramedia on 22/12/22.
//

import Foundation

enum ReaderConfigurator{
    static func configurator(viewController:ReaderEbookViewController){
        let presenter = ReaderPresenter(viewController: viewController)
        let worker = ReaderWorker()
        let interactor = ReaderInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
    }
}
