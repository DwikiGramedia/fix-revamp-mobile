//
//  ReaderViewOnSelectionChangedListener.swift
//  SCOOP
//
//  Created by Gramedia on 07/12/22.
//

import Foundation
import ColibrioReader

enum ActionStatus{
    case saveHighlight
    case saveBookmark
    case saveLastUpdate
    case deleteBookMark
    case deleteHighlight
    case initiate
}

final class ReaderViewOnSelectionChangedListener:CoreDataBrain,OnSelectionChangedListener{
    
    var book:Book
    private var dataSample:ColibrioReader.SelectionChangedEngineEventData?
    var statusAction:ActionStatus
    
    init(book: Book, statusAction: ActionStatus) {
        self.book = book
        self.statusAction = statusAction
    }
    
    func onSelectionChanged(selectionData: ColibrioReader.SelectionChangedEngineEventData) {
        dataSample = selectionData
        print(selectionData)
        if statusAction == .saveLastUpdate {
            saveLastUpdate(selectionData: selectionData)
        } else if statusAction == .saveBookmark {
            
        } else if statusAction == .saveHighlight {
            
        } else if statusAction == .deleteHighlight {
            
        } else if statusAction == .deleteBookMark {
            
        } else {
            
        }
    }
    
    private func saveLastUpdate (selectionData: ColibrioReader.SelectionChangedEngineEventData){
        book.lastSampleData = selectionData.locator?.selectors.first
        book.lastUpdatePath = selectionData.locator?.sourceUrl
        do {
            try context.save()
        }catch let error {
            print(error)
        }
    }
    
    
}
