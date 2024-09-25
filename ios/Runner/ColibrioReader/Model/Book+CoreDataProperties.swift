//
//  Book+CoreDataProperties.swift
//  Runner
//
//  Created by Samuel Napitupulu on 30/05/23.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var brandId: Int32
    @NSManaged public var created_at: Date?
    @NSManaged public var editionCode: String?
    @NSManaged public var filePathBook: String?
    @NSManaged public var filePathZip: String?
    @NSManaged public var fileType: String?
    @NSManaged public var fontSize: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var indexAlignment: Int16
    @NSManaged public var indexFontFamily: Int16
    @NSManaged public var indexSwipeDirection: Int16
    @NSManaged public var indexTheme: Int16
    @NSManaged public var key: String?
    @NSManaged public var lastPageIndex: Int32
    @NSManaged public var lastSampleData: String?
    @NSManaged public var lastUpdatePath: String?
    @NSManaged public var lineHeightSize: Int16
    @NSManaged public var productId: Int32
    @NSManaged public var title: String?
    @NSManaged public var totalPage: Int32
    @NSManaged public var watermark: String?
    @NSManaged public var bookmarks: NSSet?
    @NSManaged public var hightlights: NSSet?
    
    public var highlightArray:[Highlight]{
        let set = hightlights as? Set<Highlight> ?? []
        return set.sorted{
            $0.created_at! < $1.created_at!
        }
    }
    
    public var bookmarkArray:[Bookmark]{
        let set = bookmarks as? Set<Bookmark> ?? []
        return set.sorted{
            ($0.created_at ?? Date())  > ($1.created_at ?? Date())
        }
    }
}

// MARK: Generated accessors for bookmarks
extension Book {

    @objc(addBookmarksObject:)
    @NSManaged public func addToBookmarks(_ value: Bookmark)

    @objc(removeBookmarksObject:)
    @NSManaged public func removeFromBookmarks(_ value: Bookmark)

    @objc(addBookmarks:)
    @NSManaged public func addToBookmarks(_ values: NSSet)

    @objc(removeBookmarks:)
    @NSManaged public func removeFromBookmarks(_ values: NSSet)

}

// MARK: Generated accessors for hightlights
extension Book {

    @objc(addHightlightsObject:)
    @NSManaged public func addToHightlights(_ value: Highlight)

    @objc(removeHightlightsObject:)
    @NSManaged public func removeFromHightlights(_ value: Highlight)

    @objc(addHightlights:)
    @NSManaged public func addToHightlights(_ values: NSSet)

    @objc(removeHightlights:)
    @NSManaged public func removeFromHightlights(_ values: NSSet)

}

extension Book : Identifiable {

}
