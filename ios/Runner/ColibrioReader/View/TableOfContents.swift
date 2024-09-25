//
//  TableOfContents.swift
//  SCOOP
//
//  Created by Gramedia on 23/08/22.
//

import Foundation
import UIKit

/**
 Displays table of contents, and reports selected navigation item
 */
class TableOfContentsViewController: UITableViewController {
    private static let cellReuseIdentifier = "cellId"
    private static let levelIndentation = "  "

    /// Holds the navigation items shown in the table. Used to call item selection handler
    private let navigationItems: [NavigationItem]
    /// Holds the items used by the table view
    private let tableItems: [String]
    /// Called when an item in the table is selected
    var onItemSelected: ((_ item: NavigationItem) -> Void)?

    /**
     Instantiates TableOfContentsViewController with selected navigation items and item selection handler
     - Parameters:
       - items: navigation items to show
       - onItemSelected: called on item selection
     */
    init(items: [NavigationItem]) {
        navigationItems = items
        tableItems = navigationItems.map { item -> String in
            String(repeating: TableOfContentsViewController.levelIndentation, count: item.level) + item.title
        }

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TableOfContentsViewController.cellReuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableOfContentsViewController.cellReuseIdentifier)!

        cell.textLabel?.text = tableItems[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        onItemSelected?(navigationItems[indexPath.row])
    }
}
