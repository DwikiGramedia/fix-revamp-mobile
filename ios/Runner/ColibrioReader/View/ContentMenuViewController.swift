//
//  ContentMenuViewController.swift
//  SCOOP
//
//  Created by Gramedia on 25/11/22.
//

import UIKit
import SnapKit

protocol ContentMenuDelegate:Any{
    func goingToBookMark(bookMark:Bookmark)
    func reload(tableView:UITableView)
}


class ContentMenuViewController: UITableViewController {
    
    var book:Book
    var delegate:ContentMenuDelegate?
    
    init(book:Book){
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.reload(tableView: tableView)
        setupView()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BookMarkTableViewCell.cellIdentifier)
        tableView.alwaysBounceVertical = false
        // Do any additional setup after loading the view.
    }
    
    func reload(){
        tableView.reloadData()
    }
    
    private func setupView(){
        print(book.bookmarkArray.count)
        
        tableView.contentInset = .init(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ContentMenuViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.bookmarkArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(book.bookmarkArray[indexPath.row].location ?? "")
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: BookMarkTableViewCell.cellIdentifier)!
        let bookMark = book.bookmarkArray[indexPath.row]
        //let textDeleteLast = textDeleteFirst?.dropLast(18)
        cell.textLabel?.text = book.fileType == "pdf" ?  "Halaman ke \(bookMark.page)" : "Halaman ke \(bookMark.page)%"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dismiss(animated: true)
        delegate?.goingToBookMark(bookMark: book.bookmarkArray[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leftAction = UIContextualAction(style: .destructive, title: "Delete"){(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showMessage("Delete Bookmark", "Delete Bookmark", callback: { self.dismiss(animated: true)})
            self.book.removeFromBookmarks(self.book.bookmarkArray[indexPath.row])
            self.tableView.reloadData()
            success(true)
        }
        leftAction.image = UIImage(systemName: "trash.fill")
        leftAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
}

extension ContentMenuViewController:BookMarkTableDelegate{
    func onTap(bookMark: Bookmark) {
        self.showMessage("Delete Bookmark", "Delete Bookmark", callback: { self.dismiss(animated: true)})
        BookManagerService().deleteBookMark(bookMark: bookMark)
        self.tableView.reloadData()
    }
}

