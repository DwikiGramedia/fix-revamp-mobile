//
//  BookManager.swift
//  Runner
//
//  Created by Gramedia on 20/01/23.
//

import Foundation
import ColibrioReader
import CoreData


class BookManagerService:CoreDataBrain{
    
    func updateLastHistory(book:Book,history: SimpleLocatorData,pageIndex:Int32,totalPage:Int32){
        book.lastUpdatePath = history.sourceUrl
        book.lastSampleData = history.selectors.first ?? ""
        book.lastPageIndex = pageIndex
        book.totalPage = totalPage
        book.created_at = Date()
        do {
           try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func updateLastHistoryPDF(book:Book,history:String){
        book.lastUpdatePath = history
        do {
           try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func addBookmark(book:Book,history:SimpleLocatorData?,page:Int){
        let bookMark = Bookmark(context: self.context)
        bookMark.created_at = Date()
        bookMark.urlPath = history?.sourceUrl ?? ""
        bookMark.location = history?.selectors[0] ?? ""
        bookMark.page = Int32(page)
        book.addToBookmarks(bookMark)
        do{
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func deleteBookMark(bookMark:Bookmark){
        context.delete(bookMark)
        saveData()
    }
    
    func setFontSize(book:Book?,value:Int){
        do{
            book?.fontSize = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func setFontFamily(book:Book?,value:Int){
        do{
            book?.indexFontFamily = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteAllAnalytic(){
        do{
            let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = ReaderAnalytic.fetchRequest()
            let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
            try? context.execute(batchDeleteRequest1)
            try? context.save()
            
            let valueAnalytics = try context.fetch(ReaderAnalytic.fetchRequest())
            print(valueAnalytics)
        }catch {
            
        }
    }
    
    func setAlignment(book:Book?,value:Int){
        do{
            book?.indexAlignment = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func setThemeMode(book:Book?,value:Int){
        do{
            book?.indexTheme = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func setSwipeDirection(book:Book?,value:Int){
        do{
            book?.indexSwipeDirection = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func setLineHeight(book:Book?,value:Int){
        do{
            book?.lineHeightSize = Int16(value)
            try context.save()
        }catch{
            print(error)
        }
    }
}
