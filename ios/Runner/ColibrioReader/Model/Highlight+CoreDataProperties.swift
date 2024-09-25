//
//  Highlight+CoreDataProperties.swift
//  Runner
//
//  Created by Samuel Napitupulu on 30/05/23.
//
//

import Foundation
import CoreData


extension Highlight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Highlight> {
        return NSFetchRequest<Highlight>(entityName: "Highlight")
    }

    @NSManaged public var created_at: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var location: String?
    @NSManaged public var text: String?
    @NSManaged public var urlPath: String?

}

extension Highlight : Identifiable {

}
