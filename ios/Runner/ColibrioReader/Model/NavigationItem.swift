//
//  NavigationItem.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//

struct NavigationItem {
    static let BASE_ITEM_LEVEL = 0

    let title: String
    let locatorSelector: String?
    let level: Int
}

enum PublicationType {
    case epub
    case pdf
}
