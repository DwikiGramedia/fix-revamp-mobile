//
//  ReaderPublicationContent.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//

import Foundation
import ColibrioReader

extension ReaderPublicationNavigationData {
    /**
     Extracts navigation collection data of type NavigationCollectionType.toc (table of contents)
     - Returns: table of contents navigation items or empty array if table of contents is not found
     */
    func getTableOfContentsAsFlatArray() -> [NavigationItem] {
        navigationCollections
                .first { data in data.type == .toc }?
                .children
                .flatMap { child in
                    child.getNavigationItemsAsFlatArray(level: NavigationItem.BASE_ITEM_LEVEL)
                } ?? []
    }
}

extension ReaderPublicationNavigationItemData {
    /**
     Builds array of navigation items containing current level and children recursively
     - Parameter level: level in navigation tree
     - Returns: array of navigation items
     */
    func getNavigationItemsAsFlatArray(level: Int) -> [NavigationItem] {
        let currentLevel = NavigationItem(title: textContent, locatorSelector: locator?.selectors.first, level: level)

        return [currentLevel] + children.flatMap { child in
            child.getNavigationItemsAsFlatArray(level: level + 1)
        }
    }
}
