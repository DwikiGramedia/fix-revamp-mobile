//
//  SettingReaderViewController.swift
//  SCOOP
//
//  Created by Gramedia on 15/02/23.
//

import UIKit
import SnapKit
import ColibrioReader

protocol SettingReaderDelegate:AnyObject{
    func setFontSize(scale:Double)
    func setFontFamily(family: ColibrioReader.PublicationStyleFontSet)
    func setMarginHorizontal(value:Double)
    func setMarginVertical(value:Double)
    func setLineHeight(value:Double)
    func setThemeReader(data:PublicationStylePalette?)
    func setAlignment(alignment:ColibrioReader.PublicationStyleTextAlignmentOptions?)
    func setSwipeDirection(renderer:ColibrioReader.Renderer)
}

class SettingReaderViewController: UIViewController {
    
    private var sampleLabelFontView:UIView = {
        let uiview = UIView()
        uiview.cornersRadius = 12
        uiview.bordersColor = .black
        uiview.bordersWidth = 1
        uiview.backgroundColor = .white
        return uiview
    }()
    
    private var sampleLabel:UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
        label.numberOfLines = 0
        return label
    }()
    
    private var percentageSizeButtonLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private var percentageSizeHeightButtonLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private var percentageVHMarginScaleButtonLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private var percentageHVMarginScaleButtonLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    
    var indicatorLeftAlignment:UIView!
    var indicatorCenterAlignment:UIView!
    
    var indicatorFlipBook:UIView!
    var indicatorVerticalScrollBook:UIView!
    var indicatorTwoPagesBook:UIView!
    
    var lightTheme:UIButton!
    var darkTheme:UIButton!
    var brownTheme:UIButton!
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        collectionView.contentInset = .init(top: 2, left: 16, bottom: 2, right: 16)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let dataArray:[PublicationStylePalette?] = ListDataReader.init().dataTheme
    
    let listFontFamily:[FontFamilyStyle] = ListDataReader.init().dataFontFamily
    
    let listSwipeDirection:[ColibrioReader.Renderer] = ListDataReader.init().dataSwipeDirection
    
    let listAlignment:[ColibrioReader.PublicationStyleTextAlignmentOptions?] = ListDataReader.init().dataAlignment
    
    var fontSize:Int = 100
    var lineHeightSize:Int = 100
    var indexAlignmet:Int = 2
    var indexSwipeDirection:Int = 0
    var indexTheme:Int = 0
    var indexFontFamily:Int = 0
    var vMargins:Double = 0.2
    var hMargins:Double = 0.2
    var fontFamily:String = ""
    var delegate: SettingReaderDelegate?
    var book:Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setAlignmet()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        collectionView.register(FontFamilyCollectionViewCell.self, forCellWithReuseIdentifier: FontFamilyCollectionViewCell.cellIndetifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = .white
        var titleFontFamilyLabel:UILabel = UILabel()
        titleFontFamilyLabel.text = "Font Family"
        titleFontFamilyLabel.textColor = .black
        titleFontFamilyLabel.font = FontStyle.custom(16, weight: .semibold).font
        view.addSubview(titleFontFamilyLabel)
        titleFontFamilyLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top).offset(28)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(titleFontFamilyLabel.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        var stackviewDistribution = UIStackView()
        stackviewDistribution.distribution = .fillEqually
        stackviewDistribution.spacing = 48
        view.addSubview(stackviewDistribution)
        stackviewDistribution.snp.makeConstraints{ make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        var verticalFontSize = UIStackView()
        verticalFontSize.axis = .vertical
        verticalFontSize.distribution = .fillEqually
        verticalFontSize.spacing = 0
        stackviewDistribution.addArrangedSubview(verticalFontSize)
        var labelFontSize = UILabel()
        labelFontSize.text = "Font Size"
        labelFontSize.font = FontStyle.custom(16, weight: .semibold).font
        labelFontSize.textAlignment = .left
        labelFontSize.textColor = .black
        verticalFontSize.addArrangedSubview(labelFontSize)
        
        var fontSizeView = UIView()
        
        verticalFontSize.addArrangedSubview(fontSizeView)

        var stackviewFontConfiguration = UIStackView()
        stackviewFontConfiguration.spacing = 8
        stackviewFontConfiguration.axis = .horizontal
        
        stackviewFontConfiguration.alignment = .leading
        //fontSizeView.addSubview(stackviewFontConfiguration)
        fontSizeView.snp.makeConstraints{ make in
            make.width.equalTo(UIScreen.maxWidth * 0.5)
        }
//        stackviewFontConfiguration.snp.makeConstraints{ make in
//            make.left.equalTo(fontSizeView.snp.left).offset(-36)
//            make.top.bottom.equalTo(fontSizeView)
//            make.width.equalTo(UIScreen.maxWidth * 0.25)
//        }
        var scaleDownFontSizeButton = createButton(title: "minus.square")
        scaleDownFontSizeButton.addTarget(self, action: #selector(downScaleSizeButtonAction), for: .touchUpInside)
        fontSizeView.addSubview(scaleDownFontSizeButton)
        scaleDownFontSizeButton.snp.makeConstraints{ make in
            make.left.equalTo(fontSizeView.snp.left).offset(-12)
            make.top.equalTo(fontSizeView.snp.top)
            make.bottom.equalTo(fontSizeView.snp.bottom)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        percentageSizeButtonLabel.text = "\(Int(fontSize))%"
        percentageSizeButtonLabel.textColor = .black
        fontSizeView.addSubview(percentageSizeButtonLabel)
        percentageSizeButtonLabel.snp.makeConstraints{make in
            make.left.equalTo(scaleDownFontSizeButton.snp.right).offset(12)
            make.top.equalTo(fontSizeView.snp.top)
            make.bottom.equalTo(fontSizeView.snp.bottom)
        }
        
        var scaleUpFontSizeButton = createButton(title: "plus.square")
        scaleUpFontSizeButton.addTarget(self, action: #selector(upScaleSizeButtonAction), for: .touchUpInside)
        fontSizeView.addSubview(scaleUpFontSizeButton)
        scaleUpFontSizeButton.snp.makeConstraints{ make in
            make.left.equalTo(percentageSizeButtonLabel.snp.right).offset(12)
            make.top.equalTo(fontSizeView.snp.top)
            make.bottom.equalTo(fontSizeView.snp.bottom)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
//        stackviewFontConfiguration.addArrangedSubview(scaleDownFontSizeButton)
//        stackviewFontConfiguration.addArrangedSubview(percentageSizeButtonLabel)
//        stackviewFontConfiguration.addArrangedSubview(scaleUpFontSizeButton)
//        verticalFontSize.addArrangedSubview(stackviewFontConfiguration)
        
        var verticalLineHeight = UIStackView()
        verticalLineHeight.axis = .vertical
        verticalLineHeight.spacing = 2
        verticalLineHeight.distribution = .fillEqually
        stackviewDistribution.addArrangedSubview(verticalLineHeight)
        var labelLineHeight = UILabel()
        labelLineHeight.text = "Line Height"
        labelLineHeight.font = FontStyle.custom(16, weight: .semibold).font
        labelLineHeight.textColor = .black
        labelLineHeight.textAlignment = .left
        verticalLineHeight.addArrangedSubview(labelLineHeight)
        
        var lineHeightView = UIView()
        verticalLineHeight.addArrangedSubview(lineHeightView)
        lineHeightView.snp.makeConstraints{ make in
            make.width.equalTo(UIScreen.maxWidth * 0.5)
        }
        
        var scaleDownLineHeight = createButton(title: "minus.square")
        scaleDownLineHeight.addTarget(self, action: #selector(downScaleHeightSizeButtonAction), for: .touchUpInside)
        lineHeightView.addSubview(scaleDownLineHeight)
        scaleDownLineHeight.snp.makeConstraints{ make in
            make.left.equalTo(lineHeightView.snp.left).offset(-12)
            make.top.equalTo(lineHeightView.snp.top)
            make.bottom.equalTo(lineHeightView.snp.bottom)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        percentageSizeHeightButtonLabel.text = "\(Int(lineHeightSize))%"
        percentageSizeHeightButtonLabel.textColor = .black
        lineHeightView.addSubview(percentageSizeHeightButtonLabel)
        percentageSizeHeightButtonLabel.snp.makeConstraints{ make in
            make.left.equalTo(scaleDownLineHeight.snp.right).offset(12)
            make.top.equalTo(lineHeightView.snp.top)
            make.bottom.equalTo(lineHeightView.snp.bottom)
        }
        
        var scaleUpLineHeight = createButton(title: "plus.square")
        scaleUpLineHeight.addTarget(self, action: #selector(upScaleHeightSizeButtonAction), for: .touchUpInside)
        lineHeightView.addSubview(scaleUpLineHeight)
        scaleUpLineHeight.snp.makeConstraints{ make in
            make.left.equalTo(percentageSizeHeightButtonLabel.snp.right).offset(12)
            make.top.equalTo(lineHeightView.snp.top)
            make.bottom.equalTo(lineHeightView.snp.bottom)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
//        var stackviewLineHeightConfiguration = UIStackView()
//        stackviewLineHeightConfiguration.spacing = 8
//        stackviewLineHeightConfiguration.distribution = .equalCentering
//        stackviewLineHeightConfiguration.addArrangedSubview(scaleDownLineHeight)
//        stackviewLineHeightConfiguration.addArrangedSubview(percentageSizeHeightButtonLabel)
//        stackviewLineHeightConfiguration.addArrangedSubview(scaleUpLineHeight)
//        verticalLineHeight.addArrangedSubview(stackviewLineHeightConfiguration)
        
        var stackviewSecondDistribution = UIStackView()
        stackviewSecondDistribution.distribution = .fillEqually
        stackviewSecondDistribution.spacing = 48
        view.addSubview(stackviewSecondDistribution)
        stackviewSecondDistribution.snp.makeConstraints{ make in
            make.top.equalTo(stackviewDistribution.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        var verticalStackviewAlignmet = UIStackView()
        verticalStackviewAlignmet.axis = .vertical
        verticalStackviewAlignmet.distribution = .fillEqually
        verticalStackviewAlignmet.spacing = 6
        stackviewSecondDistribution.addArrangedSubview(verticalStackviewAlignmet)
        
        var labelAlignment = UILabel()
        labelAlignment.text = "Text Alignment"
        labelAlignment.font = FontStyle.custom(16, weight: .semibold).font
        labelAlignment.textColor = .black
        labelAlignment.textAlignment = .left
        verticalStackviewAlignmet.addArrangedSubview(labelAlignment)
        var listAligmentStackview = UIStackView()
        listAligmentStackview.axis = .horizontal
        listAligmentStackview.distribution = .fillEqually
        
        var leftAlignemtStackview = UIStackView()
        leftAlignemtStackview.axis = .vertical
        leftAlignemtStackview.spacing = 4
        indicatorLeftAlignment = UIView()
        var leftAlignmentButton = createBlackButton(title: "text.alignleft")
        leftAlignmentButton.addTarget(self, action: #selector(setLeftAlignment), for: .touchUpInside)
        indicatorLeftAlignment.backgroundColor = .blue
        indicatorLeftAlignment.cornersRadius = 1
        indicatorLeftAlignment.snp.makeConstraints{ make in
            make.height.equalTo(4)
        }
        leftAlignemtStackview.addArrangedSubview(leftAlignmentButton)
        leftAlignemtStackview.addArrangedSubview(indicatorLeftAlignment)
        
        var centerAlignmetStackview = UIStackView()
        centerAlignmetStackview.axis = .vertical
        centerAlignmetStackview.spacing = 4
        
        var centerAlignmentButton = createBlackButton(title: "text.justify")
        centerAlignmentButton.addTarget(self, action: #selector(setCenterAlignment), for: .touchUpInside)
        indicatorCenterAlignment = UIView()
        indicatorCenterAlignment.backgroundColor = .blue
        indicatorCenterAlignment.cornersRadius = 1
        indicatorCenterAlignment.snp.makeConstraints{ make in
            make.height.equalTo(4)
        }
        
        centerAlignmetStackview.addArrangedSubview(centerAlignmentButton)
        centerAlignmetStackview.addArrangedSubview(indicatorCenterAlignment)
        
        listAligmentStackview.addArrangedSubview(leftAlignemtStackview)
        listAligmentStackview.addArrangedSubview(centerAlignmetStackview)
        verticalStackviewAlignmet.addArrangedSubview(listAligmentStackview)
        
        var verticalSwipeDirectionStackview = UIStackView()
        verticalSwipeDirectionStackview.axis = .vertical
        verticalSwipeDirectionStackview.spacing = 6
        verticalSwipeDirectionStackview.distribution = .fillEqually
        stackviewSecondDistribution.addArrangedSubview(verticalSwipeDirectionStackview)
        
        var labelSwipeDirection = UILabel()
        labelSwipeDirection.text = "Swipe Direction"
        labelSwipeDirection.textColor = .black
        labelSwipeDirection.font = FontStyle.custom(16, weight: .semibold).font
        labelSwipeDirection.textAlignment = .left
        verticalSwipeDirectionStackview.addArrangedSubview(labelSwipeDirection)
        
        var listSwipeDirection = UIStackView()
        listSwipeDirection.axis = .horizontal
        listSwipeDirection.distribution = .fillEqually
        listSwipeDirection.spacing = 6
        verticalSwipeDirectionStackview.addArrangedSubview(listSwipeDirection)
        
        var flipBookStackview = UIStackView()
        flipBookStackview.axis = .vertical
        flipBookStackview.spacing = 4
        
        var flipbookButton = createAssetBlackButton(imageAsset: "singleReader")
        flipbookButton.addTarget(self, action: #selector(setFlipBook), for:.touchUpInside)
        indicatorFlipBook = UIView()
        indicatorFlipBook.backgroundColor = .blue
        indicatorFlipBook.cornersRadius = 1
        indicatorFlipBook.snp.makeConstraints{ make in
            make.height.equalTo(4)
        }
        flipBookStackview.addArrangedSubview(flipbookButton)
        flipBookStackview.addArrangedSubview(indicatorFlipBook)
        listSwipeDirection.addArrangedSubview(flipBookStackview)
        
        var pagebookStackview = UIStackView()
        pagebookStackview.axis = .vertical
        pagebookStackview.spacing = 4
        var pagebookButton = createAssetBlackButton(imageAsset: "splitReader")
        pagebookButton.addTarget(self, action: #selector(setSpreadbook), for: .touchUpInside)
        indicatorTwoPagesBook = UIView()
        indicatorTwoPagesBook.backgroundColor = .blue
        indicatorTwoPagesBook.cornersRadius = 1
        indicatorTwoPagesBook.snp.makeConstraints{ make in
            make.height.equalTo(4)
        }
        pagebookStackview.addArrangedSubview(pagebookButton)
        pagebookStackview.addArrangedSubview(indicatorTwoPagesBook)
        listSwipeDirection.addArrangedSubview(pagebookStackview)

        
        var scrollStackview = UIStackView()
        scrollStackview.axis = .vertical
        scrollStackview.spacing = 4
        var scrollButton = createBlackButton(title: "arrow.up.arrow.down")
        scrollButton.addTarget(self, action: #selector(setScrollContentbook), for: .touchUpInside)
        indicatorVerticalScrollBook = UIView()
        indicatorVerticalScrollBook.backgroundColor = .blue
        indicatorVerticalScrollBook.cornersRadius = 1
        indicatorVerticalScrollBook.snp.makeConstraints{ make in
            make.height.equalTo(4)
        }
        scrollStackview.addArrangedSubview(scrollButton)
        scrollStackview.addArrangedSubview(indicatorVerticalScrollBook)
        listSwipeDirection.addArrangedSubview(scrollStackview)
        
        var vstackTheme = UIStackView()
        vstackTheme.axis = .vertical
        vstackTheme.spacing = 16

        view.addSubview(vstackTheme)
        vstackTheme.snp.makeConstraints{  make in
            make.top.equalTo(stackviewSecondDistribution.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        var labelTheme = UILabel()
        labelTheme.text = "Theme"
        labelTheme.font = FontStyle.custom(16, weight: .semibold).font
        labelTheme.textColor = .black
        labelTheme.textAlignment = .left
        
        vstackTheme.addArrangedSubview(labelTheme)
        
        var listTheme = UIStackView()
        listTheme.axis = .horizontal
        listTheme.distribution = .fillEqually
        listTheme.spacing = 16
        vstackTheme.addArrangedSubview(listTheme)
        
        lightTheme = UIButton()
        lightTheme.setTitle("Light", for: .normal)
        
        lightTheme.addTarget(self, action: #selector(lightThemeButtonAction), for: .touchUpInside)
        listTheme.addArrangedSubview(lightTheme)
        
        darkTheme = UIButton()
        darkTheme.setTitle("Dark", for: .normal)
        darkTheme.tintColor = .white
        darkTheme.backgroundColor = .black
        darkTheme.layer.cornerRadius = 12
        darkTheme.layer.borderWidth = 1.0
        darkTheme.addTarget(self, action: #selector(darkThemeButtonAction), for: .touchUpInside)
        listTheme.addArrangedSubview(darkTheme)
        
        brownTheme = UIButton()
        brownTheme.setTitle("Brown", for: .normal)
        brownTheme.backgroundColor = .systemBrown
        brownTheme.layer.cornerRadius = 12
        brownTheme.layer.borderWidth = 1.0
        brownTheme.addTarget(self, action: #selector(brownThemeButtonAction), for: .touchUpInside)
        listTheme.addArrangedSubview(brownTheme)
        
        
        setIndexBefore()
        
    }
    
    private func setIndexBefore(){
        fontSize = Int((book?.fontSize ?? 100 < 70 ? 100 : book?.fontSize) ??  0)
        lineHeightSize = Int(book?.lineHeightSize ?? 100 <  70 ? 100 : book?.lineHeightSize ?? 0)
        indexTheme = Int(book?.indexTheme ?? 0)
        indexSwipeDirection = Int(book?.indexSwipeDirection ?? 0)
        indexFontFamily = Int(book?.indexFontFamily ?? 0)
        indexAlignmet = Int(book?.indexAlignment ?? 2)
        self.collectionView.selectItem(at: IndexPath(row: indexFontFamily, section: 0), animated: true, scrollPosition: .left)
        setSwipeDirection()
        setThemme()
        setAlignmet()
        percentageSizeButtonLabel.text = "\(fontSize)%"
        percentageSizeHeightButtonLabel.text = "\(Int(lineHeightSize))%"
    }
    
    @objc private func upScaleSizeButtonAction(){
        do{
            fontSize += 10
            if fontSize >= 200 {
                fontSize = 200
            }
            //Defaults.saveInt(fontSize, key: .fontSize)
            percentageSizeButtonLabel.text = "\(fontSize)%"
            BookManagerService().setFontSize(book: book, value: fontSize)
            let value = Double(Double(fontSize) / 100)
            delegate?.setFontSize(scale: value )
        }catch{
            
        }
        
    }
    
    @objc private func downScaleSizeButtonAction(){
        fontSize -= 10
        if fontSize < 70 {
            fontSize = 70
        }
        
        //Defaults.saveInt(fontSize, key: .fontSize)
        percentageSizeButtonLabel.text = "\(fontSize)%"
        BookManagerService().setFontSize(book: book, value: fontSize)
        delegate?.setFontSize(scale: Double(Double(fontSize) / 100))
    }
    
    @objc private func upScaleHeightSizeButtonAction(){
        lineHeightSize += 10
        if lineHeightSize >= 150 {
            lineHeightSize = 150
        }
        print(lineHeightSize)
        //Defaults.saveInt(lineHeightSize, key: .lineHeight)
        percentageSizeHeightButtonLabel.text = "\(Int(lineHeightSize))%"
        BookManagerService().setLineHeight(book: book, value: lineHeightSize)
        delegate?.setLineHeight(value: Double(Double(lineHeightSize) / 100))
    }
    
    @objc private func downScaleHeightSizeButtonAction(){
        lineHeightSize -= 10
        if lineHeightSize <= 70 {
            lineHeightSize = 70
        }
        //Defaults.saveInt(lineHeightSize, key: .lineHeight)
        percentageSizeHeightButtonLabel.text = "\(Int(lineHeightSize ))%"
        print(lineHeightSize)
        BookManagerService().setLineHeight(book: book, value: lineHeightSize)
        delegate?.setLineHeight(value: Double(Double(lineHeightSize) / 100))
    }
    
    @objc private func setLeftAlignment(){
        indexAlignmet = 1
        //Defaults.saveInt(indexAlignmet, key: .indexAlignment)
        setAlignmet()
        BookManagerService().setAlignment(book: book, value: indexAlignmet)
        delegate?.setAlignment(alignment: listAlignment[indexAlignmet])
    }
    
    @objc private func setCenterAlignment(){
        indexAlignmet = 2
        //Defaults.saveInt(indexAlignmet, key: .indexAlignment)
        setAlignmet()
        BookManagerService().setAlignment(book: book, value: indexAlignmet)
        delegate?.setAlignment(alignment: listAlignment[indexAlignmet])
    }
    
    @objc private func setFlipBook(){
        indexSwipeDirection = 0
        //Defaults.saveInt(indexSwipeDirection, key: .indexSwipeDirection)
        setSwipeDirection()
        BookManagerService().setSwipeDirection(book: book, value: indexSwipeDirection)
        delegate?.setSwipeDirection(renderer: listSwipeDirection[indexSwipeDirection])
    }
    
    @objc private func setSpreadbook(){
        indexSwipeDirection = 1
        //Defaults.saveInt(indexSwipeDirection, key: .indexSwipeDirection)
        setSwipeDirection()
        BookManagerService().setSwipeDirection(book: book, value: indexSwipeDirection)
        delegate?.setSwipeDirection(renderer: listSwipeDirection[indexSwipeDirection])
    }
    
    @objc private func setScrollContentbook(){
        indexSwipeDirection = 2
        //Defaults.saveInt(indexSwipeDirection, key: .indexSwipeDirection)
        setSwipeDirection()
        BookManagerService().setSwipeDirection(book: book, value: indexSwipeDirection)
        delegate?.setSwipeDirection(renderer: listSwipeDirection[indexSwipeDirection])
    }
    
    private func setAlignmet(){
        if indexAlignmet == 1 {
            indicatorLeftAlignment.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
            indicatorCenterAlignment.backgroundColor = .clear
        } else if indexAlignmet == 2 {
            indicatorLeftAlignment.backgroundColor = .clear
            indicatorCenterAlignment.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
        }
    }
    
    private func setSwipeDirection(){
        if indexSwipeDirection == 0 {
            indicatorFlipBook.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
            indicatorTwoPagesBook.backgroundColor = .clear
            indicatorVerticalScrollBook.backgroundColor = .clear
        } else if indexSwipeDirection == 1 {
            indicatorFlipBook.backgroundColor = .clear
            indicatorTwoPagesBook.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
            indicatorVerticalScrollBook.backgroundColor = .clear
        } else if indexSwipeDirection == 2 {
            indicatorFlipBook.backgroundColor = .clear
            indicatorTwoPagesBook.backgroundColor = .clear
            indicatorVerticalScrollBook.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
        }
    }
    
    private func setThemme(){
        if indexTheme == 0 {
            lightTheme.setTitleColor(.black, for: .normal)
            lightTheme.layer.cornerRadius = 12
            lightTheme.layer.borderWidth = 1.0
            darkTheme.layer.borderWidth = 0
            darkTheme.setTitleColor(.black, for: .normal)
            darkTheme.backgroundColor = .white
            darkTheme.layer.cornerRadius = 12
            brownTheme.setTitleColor(.black, for: .normal)
            brownTheme.layer.borderWidth = 0
            brownTheme.backgroundColor = .white
            brownTheme.layer.cornerRadius = 12
        } else if indexTheme == 1 {
            lightTheme.setTitleColor(.black, for: .normal)
            lightTheme.layer.cornerRadius = 12
            lightTheme.layer.borderWidth = 0
            darkTheme.layer.borderWidth = 1.0
            darkTheme.setTitleColor(.white, for: .normal)
            darkTheme.backgroundColor = .black
            darkTheme.layer.cornerRadius = 12
            brownTheme.layer.borderWidth = 0
            brownTheme.backgroundColor = .white
            brownTheme.layer.cornerRadius = 12
            brownTheme.setTitleColor(.black, for: .normal)
        } else if indexTheme == 2 {
            lightTheme.setTitleColor(.black, for: .normal)
            lightTheme.layer.cornerRadius = 12
            lightTheme.layer.borderWidth = 0
            darkTheme.layer.borderWidth = 0
            darkTheme.setTitleColor(.black, for: .normal)
            darkTheme.backgroundColor = .white
            darkTheme.layer.cornerRadius = 12
            brownTheme.layer.borderWidth = 1.0
            brownTheme.backgroundColor = .brown
            brownTheme.setTitleColor(.white, for: .normal)
            brownTheme.layer.cornerRadius = 12
        }
    }
    
    @objc private func upScaleMarginsVerticalButtonAction(){
        vMargins += 0.1
        if vMargins >= 0.5 {
            vMargins = 0.5
        }
        percentageVHMarginScaleButtonLabel.text = "\(vMargins * 100)%"
        delegate?.setMarginVertical(value: vMargins)
    }
    
    @objc private func downScaleMarginsVerticalButtonAction(){
        vMargins -= 0.1
        if vMargins <= 0.0 {
            vMargins = 0.0
        }
        percentageVHMarginScaleButtonLabel.text = "\(vMargins * 100)%"
        delegate?.setMarginVertical(value: vMargins)
    }
    
    @objc private func upScaleMarginsHorizontalButtonAction(){
        hMargins += 0.1
        if hMargins >= 0.5 {
            hMargins = 0.5
        }
        percentageHVMarginScaleButtonLabel.text = "\(hMargins * 100)%"
        delegate?.setMarginHorizontal(value: hMargins)
    }
    
    @objc private func downScaleMarginsHorizontalButtonAction(){
        hMargins -= 0.1
        if hMargins >= 0.0 {
            hMargins = 0.0
        }
        percentageHVMarginScaleButtonLabel.text = "\(hMargins * 100)%"
        delegate?.setMarginHorizontal(value: hMargins)
    }
    
    @objc private func lightThemeButtonAction(){
        indexTheme = 0
        //Defaults.saveInt(indexTheme, key: .indexTheme)
        setThemme()
        BookManagerService().setThemeMode(book: book, value: indexTheme)
        delegate?.setThemeReader(data: dataArray[indexTheme])
    }
    
    @objc private func darkThemeButtonAction(){
        indexTheme = 1
        //Defaults.saveInt(indexTheme, key: .indexTheme)
        setThemme()
        BookManagerService().setThemeMode(book: book, value: indexTheme)
        delegate?.setThemeReader(data: dataArray[indexTheme])
    }
    
    @objc private func brownThemeButtonAction(){
        indexTheme = 2
        //Defaults.saveInt(indexTheme, key: .indexTheme)
        setThemme()
        BookManagerService().setThemeMode(book: book, value: indexTheme)
        delegate?.setThemeReader(data: dataArray[indexTheme])
    }
}

extension SettingReaderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFontFamily.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: FontFamilyCollectionViewCell.cellIndetifier, for: indexPath) as? FontFamilyCollectionViewCell else {
            fatalError("Cannot found collection cell")
        }
        collectionCell.fontFamily = listFontFamily[indexPath.row]
        collectionCell.isSelected = indexPath.row == indexFontFamily
        return collectionCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexFontFamily = indexPath.row
        BookManagerService().setFontFamily(book: book, value: indexFontFamily)
        delegate?.setFontFamily(family: listFontFamily[indexPath.row].fontSet)
    }
}
