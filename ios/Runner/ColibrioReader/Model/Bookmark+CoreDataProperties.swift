//
//  Bookmark+CoreDataProperties.swift
//  Runner
//
//  Created by Samuel Napitupulu on 30/05/23.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var page: Int32
    @NSManaged public var urlPath: String?

}

extension Bookmark : Identifiable {

}
