//
//  BookMarkTableViewCell.swift
//  SCOOP
//
//  Created by Gramedia on 09/12/22.
//

import UIKit
import SnapKit

protocol BookMarkTableDelegate:Any{
    func onTap(bookMark:Bookmark)
}

class BookMarkTableViewCell: UITableViewCell {

    static let cellIdentifier:String = "bookMarkCell"
    var bookMark:Bookmark?{
        didSet{
            
        }
    }
    var delegate:BookMarkTableDelegate?
    
    private var stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var label:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private var button:UIButton {
        let button = UIButton()
        button.imageView?.image = UIImage(systemName: "trash.fill")
        button.imageView?.tintColor = .red
        return button
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(stackView)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        // Initialization code
    }
    
    @objc func onTap(){
        delegate?.onTap(bookMark: bookMark!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
