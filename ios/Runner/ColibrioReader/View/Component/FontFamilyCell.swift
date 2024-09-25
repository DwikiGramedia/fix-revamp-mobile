//
//  FontFamilyCell.swift
//  Runner
//
//  Created by Chondro on 22/05/23.
//

import UIKit

class FontFamilyCollectionViewCell: UICollectionViewCell {
    
    static var cellIndetifier = "FontFamilyCell"
    
    lazy var labelFont:UILabel = {
        let label = UILabel()
        label.text = "Aa"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var divider: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()
    
    override var isSelected: Bool{
        didSet{
            divider.backgroundColor = isSelected ? .bluePrimaryMain : .clear
        }
    }
    
    var fontFamily: FontFamilyStyle? {
        didSet {
            if let font = fontFamily {
                setupData(fontName: font.fontFamily, fontAsset: font.fontAsset)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent(){
        [labelFont, titleLabel, divider].forEach {
            contentView.addSubview($0)
            contentView.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: $0)
        }
        contentView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1]->=4-[v2]|", views: labelFont, titleLabel, divider)
    }
    
    private func setupData(fontName:String,fontAsset:String){
        labelFont.font = UIFont(name: fontAsset, size: 20)
        titleLabel.font = UIFont(name: fontName, size: 12)
        titleLabel.text = fontName
    }
}

