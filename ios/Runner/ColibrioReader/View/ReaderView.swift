//
//  ReaderEbookViewController.swift
//  Gramedia Digital
//
//  Created by Chondro on 12/04/23.
//

import UIKit
import ColibrioReader

import FloatingPanel
import SnapKit

/**
 Main view controller responsible for loading and showing a publication.
 */
final class ReaderEbookViewController: UIViewController, FloatingPanelControllerDelegate {

    var colibrioView: ColibrioView!
    var readingSystemEngine: ReadingSystemEngine!
    var readerView: ReaderView!
    
    let documentPickerHandler: DocumentPicker = DocumentPicker()

    var stackView: UIStackView!
    var topControlsView: UIView!
    var playPauseButton: UIButton!
    var clearSearchButton: UIButton!
    var contentPositionTimelineSlider: UISlider!
    var contentPositionTimelineSliderTrailingWithMediaButton: NSLayoutConstraint!
    var contentPositionTimelineSliderTrailingFullWidth: NSLayoutConstraint!

    var bottomControlsView: UIView!
    var previousButton: UIButton!
    var nextButton: UIButton!
    
    lazy var secureTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        return view
    }()
    
    lazy var labelOfPages:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    var searchAgent:ReaderViewSearchAgent?
    var date:Date?
    
    var windowInterfaceOrientation: UIInterfaceOrientation? {
           return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
       }
    
    /// Bottomsheet custom
    var floatingPanel:FloatingPanelController!

    /// Table of Contents (ToC) button
    var tocBarButtonItem: UIBarButtonItem!
    var settingsButtonItem: UIBarButtonItem!
    var menuBarButtonItem: UIBarButtonItem!
    var bookMarkButtonItem: UIBarButtonItem!
    var searchButtonItem: UIBarButtonItem!
    var unBookmarkButtonItem: UIBarButtonItem!
    
    /// Watermark
    var watermarkLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    var watermarkLabel2:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.textColor = .black.withAlphaComponent(0.1)
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    var watermarkLabel3:UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.1)
        label.numberOfLines = 1;
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    var watermarkLabel4:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.textColor = .black.withAlphaComponent(0.1)
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()

    /// The base URL used when creating Locators pointing to content in the loaded publication
    private var publicationLocatorUrl: String?
    /// The table of contents represented as an array of ``NavigationItem``
    private var tableOfContents: [NavigationItem] = []
    private var syncMediaPlayer: SyncMediaPlayer?
    private var contentMenu:ContentMenuViewController?
    var footnoteLocator:SimpleLocatorData?
    var footnoteIndexSpine:Int?
    var interactor:ReaderInteractor?
    var timer:Timer?

    private var contentPositionTimeline: ContentPositionTimeline?
    private var onVisibleContentChangedListener: ReaderViewOnVisibleContentChangedListener!
    
    var isBookmark = false
    var floatingPanelState: FloatingPanelState = .tip
    var pageInt = 0
    var timeDuration:Double = 0.0
    var hideTimeDuration:Double = 0.0
    var fireSendAnalytics: Double = 0.0
    var isHiddenTopandBottom = false
    var isOpen = false
    
    var keywordsContent: String = ""
    
    var pageView:[Pageview] = []
    var pageViewEpp:[PageViewEpp] = []
    //private var tokenProvider: TokenProvider!
    var url:URL
    var book:Book
    
    init(url:URL,book:Book) {
        self.url = url
        self.book = book
        super.init(nibName: nil, bundle: nil)
        ReaderConfigurator.configurator(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Holds the last picked publication URL
    private var pickedPublicationUrl: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstTimeVisitReader()
        onDocumentPicked(url: url)
        date = Date()
        //hideContentOnScreenCapture()
        //setNavigation(isHidden: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setupview of layouting
        setupViews()
        resetControlsVisibility()
        readingSystemEngine = colibrioView.getReadingSystemEngine()
        readerView = readingSystemEngine.readerView
        colibrioView.setAllowedCalloutActions([CalloutAction.custom("Wohoo")])
        floatingPanel = FloatingPanelController(delegate: self)
        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingPanel.backdropView.dismissalTapGestureRecognizer.addTarget(self, action: #selector(closeBackdropView))
        
        onVisibleContentChangedListener = ReaderViewOnVisibleContentChangedListener(contentPositionTimelineSlider: contentPositionTimelineSlider, delegate: self)
        readerView.addOnVisibleContentChangedListener(onVisibleContentChangedListener)
        readerView.addOnMouseEventListener(self)
        readerView.addOnNavigationIntentEventListener(self)
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            self.showMessage("Tidak bisa foto", "Tidak diperbolehkan mengambil foto buku")
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                              selector: #selector(self.updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
        setupLoadingImageAsset()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            
            if windowInterfaceOrientation.isLandscape {
                self.dismiss(animated: true)
                
                guard let locatorFootnote = self.footnoteLocator, let indexspine = self.footnoteIndexSpine else {
                    return
                }
                let showPopupFootnote = FootnoteViewController(indexSpine: indexspine, locator: locatorFootnote, urlFile: self.url)
                self.floatingPanel.set(contentViewController: showPopupFootnote)
                self.floatingPanel.layout = FootnoteLandscapePanelLayout()
                self.present(self.floatingPanel, animated: true)
            } else {
                self.dismiss(animated: true)
                guard let locatorFootnote = self.footnoteLocator, let indexspine = self.footnoteIndexSpine else {
                    return
                }
                
                let showPopupFootnote = FootnoteViewController(indexSpine: indexspine, locator: locatorFootnote, urlFile: self.url)
                self.floatingPanel.set(contentViewController: showPopupFootnote)
                self.floatingPanel.layout = IntrinsicPanelLayout()
                self.present(self.floatingPanel, animated: true)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true)
        //floatingPanel.fp_dismiss(animated: true)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        navigationController?.navigationBar.isHidden = true
        let borrowedId = UserDefaults.standard.integer(forKey: "borrowedId")
        let catalogId = UserDefaults.standard.integer(forKey: "catalogId")
        let orgId = UserDefaults.standard.integer(forKey: "organizationId")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int, let clientId = UserDefaults.standard.value(forKey: "clientId") as? Int else {
                            return
        }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = dateFormatter.string(from: self.date ?? Date())
        let pageEpp = PageViewEpp(borrowing_id: borrowedId, item_id:  Int(self.book.productId), page_orientation: "Potrait", duration: timeDuration, max_duration: timeDuration, online_status: NetworkMonitorObserver.isConnected ? "Online" : "Offline", page_number: [pageInt], chapter: "", start_time: "\(dateString)+0000", end_time: "\(dateString)+0000", device_id: UIDevice.current.identifierForVendor?.uuidString ?? "", device_model:  UIDevice.current.model, os_version: UIDevice.current.systemVersion, client_version: "3.0.4", client_id: clientId, ip_address: "192.168.0.1", datetime: "\(dateString)+0000", user_id: userId, session_name: "\(dateString)\(String(describing: UIDevice.deviceId))".sha256(), catalog_id: catalogId, organization_id: orgId)
            interactor?.postPage(page: pageEpp)
        interactor?.postEppRecord(body: RecordParameterEpp(pageviews: []))
            self.timeDuration = 0.0
        if let sampleData = readingSystemEngine.readerView.readingPosition {
            BookManagerService().updateLastHistory(book: book, history: sampleData,pageIndex: Int32(pageInt),totalPage: Int32(contentPositionTimelineSlider.maximumValue))
            UserDefaults.standard.removeObject(forKey: "keywordSearch")
            cleanUp()
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            interactor?.postEppRecord(body: RecordParameterEpp(pageviews: pageViewEpp))
        }
    }
    
    func firstTimeVisitReader() {
        let isFirstVisited = UserDefaults.standard.value(forKey: "firstTimeVisitReader") as? Bool ?? true
        if isFirstVisited == true {
            showMessageWithOptionDialog("Content Information", "It is not permitted to take pictures or screenshots of the content being read", callbackYes: { [self] in
                UserDefaults.standard.setValue(false, forKey: "firstTimeVisitReader")
                dismiss(animated: true)
            }, callbackNo: { [self] in
                navigationController?.popViewController(animated: true)
            })
        }
    }
    

    /**
     Creates views and sets up constraints
     */
    private func setupViews() {
        view.backgroundColor = .white

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16

        colibrioView = ColibrioView()
        colibrioView.translatesAutoresizingMaskIntoConstraints = false

        topControlsView = UIView()
        topControlsView.translatesAutoresizingMaskIntoConstraints = false

        playPauseButton = createButton(title: NSLocalizedString("play_button_title", comment: "Play button title"))
        playPauseButton.addTarget(self, action: #selector(togglePlayPauseMedia), for: .touchUpInside)

        contentPositionTimelineSlider = UISlider()
        contentPositionTimelineSlider.translatesAutoresizingMaskIntoConstraints = false
        contentPositionTimelineSlider.isContinuous = false
        contentPositionTimelineSlider.addTarget(self, action: #selector(contentPositionSliderValueDidChange), for: .valueChanged)
        
        self.navigationController?.navigationBar.backgroundColor = .white
        
        topControlsView.addSubview(contentPositionTimelineSlider)
        topControlsView.addSubview(playPauseButton)

        bottomControlsView = UIView()
        bottomControlsView.translatesAutoresizingMaskIntoConstraints = false
        
        let bookmarkImageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold, scale: .large)

        settingsButtonItem = UIBarButtonItem(image: UIImage(named: "text-font", in: nil,with:bookmarkImageConfig), style: .plain, target: self, action: #selector(openSettings))
        
        bookMarkButtonItem = UIBarButtonItem(image: UIImage(named: "unbookmark", in: nil,with:bookmarkImageConfig), style: .plain, target: self, action: #selector(bookMark))
        
        tocBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash",withConfiguration: bookmarkImageConfig), style: .plain, target: self, action: #selector(showTableOfContents))
        
        unBookmarkButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark", in: nil,with:bookmarkImageConfig), style: .plain, target: self, action: #selector(unBookmark))
        
        menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmarkList"), style: .plain, target: self, action: #selector(openMenu))
        
        searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass",withConfiguration: bookmarkImageConfig), style: .plain, target: self, action: #selector(openSearch))

        previousButton = createButton(title: "chevron.left")
        previousButton.addTarget(self, action: #selector(previousDocument), for: .touchUpInside)

        nextButton = createButton(title: "chevron.right")
        nextButton.addTarget(self, action: #selector(nextDocument), for: .touchUpInside)
        
        labelOfPages.text = "Loading"
        labelOfPages.textColor = .black
        
        bottomControlsView.addSubview(previousButton)
        bottomControlsView.addSubview(contentPositionTimelineSlider)
        bottomControlsView.addSubview(nextButton)
        bottomControlsView.addSubview(labelOfPages)

        // Add views
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(colibrioView)
        bottomControlsView.backgroundColor = .white
        view.addSubview(bottomControlsView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0))
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
//            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
//            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
//
//            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),

            bottomControlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            playPauseButton.topAnchor.constraint(equalTo: topControlsView.topAnchor),
            playPauseButton.trailingAnchor.constraint(equalTo: topControlsView.trailingAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: topControlsView.bottomAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 64),

            previousButton.leadingAnchor.constraint(equalTo: bottomControlsView.leadingAnchor,constant: 24),
            previousButton.bottomAnchor.constraint(equalTo: bottomControlsView.bottomAnchor,constant: -28),
            previousButton.widthAnchor.constraint(equalToConstant: 80),
      
            nextButton.bottomAnchor.constraint(equalTo: bottomControlsView.bottomAnchor,constant: -28),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.trailingAnchor.constraint(equalTo: bottomControlsView.trailingAnchor,constant: -24),
            
            contentPositionTimelineSlider.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor,constant: 24),
            contentPositionTimelineSlider.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor,constant: -24),
            contentPositionTimelineSlider.bottomAnchor.constraint(equalTo: bottomControlsView.bottomAnchor,constant: -28),

            labelOfPages.topAnchor.constraint(equalTo: bottomControlsView.topAnchor,constant: 8),
            labelOfPages.bottomAnchor.constraint(equalTo: contentPositionTimelineSlider.topAnchor,constant: -28),
            labelOfPages.centerXAnchor.constraint(equalTo: bottomControlsView.centerXAnchor),
        ])
        
        let imageCleaarConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        clearSearchButton = createButtonEraser(systemName: "eraser", withConfiguration: imageCleaarConfiguration)
        clearSearchButton.backgroundColor = .init(red: 0, green: 96/255, blue: 175/255, alpha: 1)
        clearSearchButton.cornersRadius = 32
        clearSearchButton.tintColor = .white
        view.addSubview(clearSearchButton)
        clearSearchButton.addTarget(self, action: #selector(clearHighlightSearching), for: .touchUpInside)
        clearSearchButton.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-UIScreen.maxHeight * 0.2)
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        clearSearchButton.isHidden = true
        colibrioView.addSubview(watermarkLabel)
        colibrioView.addSubview(watermarkLabel2)
        colibrioView.addSubview(watermarkLabel3)
        colibrioView.addSubview(watermarkLabel4)
        
    
        watermarkLabel.snp.makeConstraints{ make in
            make.left.equalTo(stackView).offset(UIScreen.maxWidth / 4)
            
            make.top.equalTo(stackView.snp.top).offset(UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        
        watermarkLabel2.snp.makeConstraints{ make in
            make.left.equalTo(stackView).offset(UIScreen.maxWidth / 4)
            
            make.bottom.equalTo(stackView.snp.bottom).offset(-UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        watermarkLabel3.snp.makeConstraints{ make in
            //make.left.equalTo(watermarkLabel.snp.right)
            make.right.equalTo(stackView.snp.right).offset(-UIScreen.maxWidth / 4)
            make.top.equalTo(stackView.snp.top).offset(UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        watermarkLabel4.snp.makeConstraints{ make in
            //make.left.equalTo(watermarkLabel2.snp.right)
            make.right.equalTo(stackView.snp.right).offset(-UIScreen.maxWidth / 4)
            make.bottom.equalTo(stackView.snp.bottom).offset(-UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
    }
    
    @objc private func updateTimer(){
        self.timeDuration += 1.0
        self.hideTimeDuration += 1.0
        if hideTimeDuration > 10.0 {
            UIView.animate(withDuration: 0.4) { [self] in
                self.navigationController?.navigationBar.isHidden = true
                self.navigationItem.rightBarButtonItems = nil
                self.navigationItem.setHidesBackButton(true, animated: true)
                self.hidesBottomBarWhenPushed = true
                self.navigationItem.leftBarButtonItems = nil
                bottomControlsView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    private func setupLoadingImageAsset(){
        do{
            let image = Bundle.main.url(forResource: "eperpuslogo.png", withExtension:nil)
            let data = try Data(contentsOf: image!)
            readingSystemEngine.readerView.setContentOnLoading(html: "<img src='data:text/plain;base64,\(data.base64EncodedString() )'>")
            guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int else {
                return 
            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id")
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: self.date ?? Date())
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: self.date ?? Date())
            dateFormatter.dateFormat = "yy"
            let year = dateFormatter.string(from: self.date ?? Date())
            let randomPosition = Int.random(in: 0...3)
            watermark(email: email, date: "\(day)\(month)\(year)", changePosition: randomPosition)

        }catch let err {
            print(err)
        }
    }

    // MARK: Load document

    @objc func openFile() {
        documentPickerHandler.presentDocumentPicker(presenterVc: self, onDocumentPicked: onDocumentPicked)
    }
    
    @objc private func openSettings(){
        let setting = SettingReaderViewController()
        setting.delegate = self
        setting.book = book
        floatingPanel.set(contentViewController: setting)
        floatingPanel.layout = FontStylePanelLayout()
        present(floatingPanel, animated: true, completion: nil)
    }
    
    @objc func openMenu(){
        contentMenu = ContentMenuViewController(book: book)
        contentMenu?.delegate = self
        self.isOpen.toggle()
        floatingPanel.set(contentViewController: contentMenu)
        floatingPanel.layout = FontStylePanelLayout()
        present(floatingPanel, animated: true)
        self.isOpen = true
        if let history = book.fileType == "pdf" ? readingSystemEngine.readerView.visibleRange : readingSystemEngine.readerView.readingPosition {
            isBookmarkApprove(page: Int(contentPositionTimelineSlider.value), locator: history)
            if isBookmark == false {
            updateRightBarButtonItem()
            } else {
            updateRightBarButtonItem()
            }
        }
    }
    
    @objc private func openSearch(){
        let search = SearchViewController(readingSystemEngine: readingSystemEngine)
        search.modalPresentationStyle = .pageSheet
        search.delegate = self
        if #available(iOS 15.0, *) {
            if let sheet = search.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        }
        present(search, animated: true)
    }
    
    @objc private func closeBackdropView(){
        self.dismiss(animated: true)
        self.footnoteLocator = nil
        self.footnoteIndexSpine = nil
    }
    
    @objc func clearHighlightSearching(){
        deleteAnnotationSearch()
        clearSearchButton.isHidden = true
    }
    
    func isBookmarkApprove(page:Int?, locator:SimpleLocatorData){
        if book.fileType == "pdf" {
            isBookmark = book.bookmarkArray.contains(where: {SimpleLocatorData(sourceUrl: $0.urlPath ?? "", selectors: [$0.location ?? ""]) == locator})
        } else {
            isBookmark = book.bookmarkArray.contains(where: {SimpleLocatorData(sourceUrl: $0.urlPath ?? "", selectors: [$0.location ?? ""]) == locator})
        }
    }
    
    @objc func bookMark(){
        let indexPage:Int = Int(( Double(pageInt) / Double(self.contentPositionTimelineSlider.maximumValue )) * 100)
        if let history = book.fileType == "pdf" ? readingSystemEngine.readerView.visibleRange : readingSystemEngine.readerView.readingPosition {
            book.fileType == "pdf" ? BookManagerService().addBookmark(book: book, history: history, page:pageInt ) :
            BookManagerService().addBookmark(book: book, history: history, page:indexPage )
            isBookmarkApprove(page: Int(contentPositionTimelineSlider.value), locator: history)
            if isBookmark == false {
                updateRightBarButtonItem()
            } else {
               updateRightBarButtonItem()
            }
        }
    }
    
    @objc func unBookmark(){
        if let history = book.fileType == "pdf" ? readingSystemEngine.readerView.visibleRange : readingSystemEngine.readerView.readingPosition {
            if let dataBookmark = book.bookmarkArray.filter({ $0.location == history.selectors[0]}).first {
                book.removeFromBookmarks(dataBookmark)
                isBookmarkApprove(page: Int(contentPositionTimelineSlider.value), locator: history)
                if isBookmark == false {
                    updateRightBarButtonItem()
                } else {
                    updateRightBarButtonItem()
                }
            }
        }
    }

    /**
     Initiates loading either an epub or a pdf file based on the given url
     - Parameter url: url of the publication file
     */
    private func onDocumentPicked(url: URL) {
        // Cleanup for previous URL
        if let pickedPublicationUrl = pickedPublicationUrl {
            pickedPublicationUrl.stopAccessingSecurityScopedResource()
        }

        pickedPublicationUrl = url
        _ = url.startAccessingSecurityScopedResource()
        
        if let fileChannelDataSource = getPublicationUrlDataSource(publicationUrl: url) {
            
            let readingSessionOptions = ReadingSessionOptions(userToken: getUserToken())

            switch url.getPublicationType() {
            case .epub:
                loadEpub(fileChannelDataSource: fileChannelDataSource, readingSessionOptions: readingSessionOptions)
            case .pdf:
                loadPDF(fileChannelDataSource: fileChannelDataSource, readingSessionOptions: readingSessionOptions)
            default:
                showMessage(NSLocalizedString("error_unsupported_file", comment: "File not supported error message"))
            }
        }
    }
    
    private func getUserToken() -> String {
        // TODO: write logic for getting user token
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int else {
            return ""
        }
        return "\(email)\(userId)".sha256()
    }
    
    /// Update navbar
    func updateRightBarButtonItem() {
        if isBookmark == false {
            if self.tableOfContents.isEmpty {
                // Hide toc button
                if book.fileType == "pdf" {
                    self.navigationItem.setRightBarButtonItems([ self.menuBarButtonItem,self.isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,self.searchButtonItem], animated: true)
                } else {
                    self.navigationItem.setRightBarButtonItems([self.settingsButtonItem, self.menuBarButtonItem,self.isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,self.searchButtonItem], animated: true)
                }
               
            }   else {
               
                self.navigationItem.setRightBarButtonItems([self.settingsButtonItem, self.menuBarButtonItem,self.isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,tocBarButtonItem,self.searchButtonItem], animated: true)
            }
        } else {
            if self.tableOfContents.isEmpty {
                // Hide toc button
                if book.fileType == "pdf" {
                    self.navigationItem.setRightBarButtonItems([ self.menuBarButtonItem,self.isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,self.searchButtonItem], animated: true)
                } else {
                    self.navigationItem.setRightBarButtonItems([self.settingsButtonItem, self.menuBarButtonItem,isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,self.searchButtonItem], animated: true)
                }
            }  else {
                self.navigationItem.setRightBarButtonItems([self.settingsButtonItem, self.menuBarButtonItem,self.isBookmark ? self.unBookmarkButtonItem : self.bookMarkButtonItem,tocBarButtonItem,self.searchButtonItem], animated: true)
            }
        }
    }

    /**
     Creates a random access data source for a given local publication file url
     - Parameter publicationUrl: url of the publication file
     - Returns: random access data source for the file, or nil in case of failure
     */
    private func getPublicationUrlDataSource(publicationUrl: URL) -> FileRandomAccessDataSource? {
        guard let dataSource = try? FileRandomAccessDataSource(url: publicationUrl) else { return nil }
        return dataSource
    }

    /**
     Loads epub publication using the given data source and reading session options
     - Parameters:
       - fileChannelDataSource: a random access data source
       - readingSessionOptions: reading session options
     */
    private func loadEpub(fileChannelDataSource: RandomAccessDataSource, readingSessionOptions: ReadingSessionOptions) {
        cleanUp()

        let epubReaderPublicationOptions = EpubReaderPublicationOptions(preventDefaultContextMenu:  false, preventDragAndDropActions: true)

        let epubPublicationConfig = EpubRandomAccessDataSourceLoadConfig(publicationDataSource: fileChannelDataSource,
                readingSessionOptions: readingSessionOptions, readerPublicationOptions: epubReaderPublicationOptions)
        readingSystemEngine.loadEpub(config: epubPublicationConfig) { [weak self] (result) in
            switch result {
            case .success(let publication):
                self?.onPublicationLoaded(publication)
            case .failure(let error):
                self?.onPublicationLoadingError(error)
            }
        }
    }

    /**
     Loads pdf publication using the given data source and reading session options
     - Parameters:
       - fileChannelDataSource: a random access data source
       - readingSessionOptions: reading session options
     */
    private func loadPDF(fileChannelDataSource: RandomAccessDataSource, readingSessionOptions: ReadingSessionOptions) {
        cleanUp()

        let pdfPublicationOptions = PdfPublicationOptions(password: book.key)
        let pdfReaderPublicationOptions = PdfReaderPublicationOptions(preventDefaultContextMenu: true,preventDragAndDropActions: true)
        let pdfPublicationConfig = PdfRandomAccessDataSourceLoadConfig(publicationDataSource: fileChannelDataSource,
                readingSessionOptions: readingSessionOptions, readerPublicationOptions: pdfReaderPublicationOptions, publicationOptions: pdfPublicationOptions)
        readingSystemEngine.loadPdf(config: pdfPublicationConfig) { [weak self] (result) in
            switch result {
            case .success(let publication):
                self?.onPublicationLoaded(publication)
            case .failure(let error):
                self?.onPublicationLoadingError(error)
            }
        }
    }

    /**
     Given a reader publication, initialises the reader view with the document and renderers.
     Then initiates fetching navigation data, and initialises sync media.

     Renderers control how the publication is presented to the user. There are several renderers available:
     - ``StackRenderer``
     - ``FlipBookRenderer``
     - ``SpreadSwipeRenderer``
     - ``SinglePageSwipeRenderer``
     - ``SingleDocumentScrollRenderer``

     This sample demonstrates using the ``StackRenderer``.

     - Parameter publication: the reader publication
     */
    private func onPublicationLoaded(_ publication: ReaderPublication) {
        // Store publication base locator url so we can easily create SimpleLocatorData objects
        publicationLocatorUrl = publication.defaultLocatorUrl

        // We don't ignore aspect ratio when the publication has fixed layout documents. Setting ignoreAspectRatio to true will use up the whole view area to render publication content
        let shouldIgnoreAspectRatio = publication.sourcePublication.defaultLayout == ContentDocumentLayout.reflowable
//        let renderer = StackRenderer(with: StackRendererOptions(ignoreAspectRatio: shouldIgnoreAspectRatio))
        if book.fileType == "pdf"{
            try? readerView.addRenderer(SinglePageSwipeRenderer(with: SinglePageSwipeRendererOptions(ignoreAspectRatio: true)))
        } else {
            readerView.responsiveRendererSelectionEnabled = true
            ListDataReader.init().dataSwipeDirection.forEach{ renderer in
                try? readerView.addRenderer(renderer, mediaQueryRule: nil)
            }
        }
        

        // Set which documents will be rendered in the reader view
        readerView.readerDocuments = publication.spine

        // Show next and prev buttons
        previousButton.isHidden = false
        nextButton.isHidden = false

        // Fetch navigation data containing the table of contents
        fetchPublicationNavigationData(publication: publication)

        // Initialise sync media
        initialiseSyncMedia(publication: publication)

        // Create content position timeline which will be used for the reading position slider
        createContentPositionTimeline(publication: publication)
        if let position = readerView.readingPosition {
            isBookmark = book.bookmarkArray.contains(where: {SimpleLocatorData(sourceUrl: $0.urlPath ?? "", selectors: [$0.location ?? ""]) == position})
            print("Bookmark state firstLoad \(isBookmark)")
            if isBookmark == false {
                updateRightBarButtonItem()
            } else {
                updateRightBarButtonItem()
            }
        }
        
        if book.lastSampleData != nil {
            
            readerView.goTo(locator: SimpleLocatorData(sourceUrl: book.lastUpdatePath ?? "", selectors: [book.lastSampleData ?? ""])){ data in
                switch data {
                case .success(_) :
                    if self.book.fileType != "pdf"{
                        self.styleReaderConfigure()
                    }
                    self.pageInt = Int(self.book.lastPageIndex)
                    
                    self.labelOfPages.text = "Page \(Int(self.book.lastPageIndex)) of \(Int(self.book.totalPage)) (\(Int(((Double(self.book.lastPageIndex ) / Double(self.book.totalPage)) * 100).roundToDecimal(0)))%)"

                case .failure(let error):
                    print(error)
                    break
                }
            }

        } else {
            self.labelOfPages.text = self.book.fileType  == "pdf" ? "Page 1 of \(contentPositionTimeline?.length ?? 0) (0%)" : "0%"
            readerView.goToStart()

        }
        
        guard let content = self.contentPositionTimeline else {
            return
        }
        
        self.onCreateContentPositionTimelineCompleted(contentPositionTimeline: content)
        
    }

    private func onPublicationLoadingError(_ error: ColibrioReaderResponseError) {
        // Show error message
        showMessage(NSLocalizedString("error_publication_loading", comment: "Publication loading error message"))
        log(error.message)
    }

    /**
     Cleans up the previously loaded publication
     */
    private func cleanUp() {
        resetControlsVisibility()

        cleanUpSyncMedia()

        cleanUpContentPositionTimeline()

        // Remove reader documents
        readerView.readerDocuments = []

        // Unload publication
        readingSystemEngine.readerPublications.forEach { publication in
            try! readingSystemEngine.unloadPublication(publication)
        }
    }

    private func resetControlsVisibility() {
        // Hide next and prev buttons
        previousButton.isHidden = true
        nextButton.isHidden = true

        // Hide media controls
        topControlsView.isHidden = true
        playPauseButton.isHidden = true
        //contentPositionTimelineSliderTrailingWithMediaButton.isActive = false
        //contentPositionTimelineSliderTrailingFullWidth.isActive = true

        // Hide reading position slider
        contentPositionTimelineSlider.isHidden = true

        // Hide table of contents button
        navigationItem.setRightBarButton(nil, animated: false)
    }

    // MARK: Navigation

    /**
     Initiates fetching publication navigation data to load the "table of contents (TOC)".
     */
    private func fetchPublicationNavigationData(publication: ReaderPublication) {
        
        publication.fetchPublicationNavigation { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let publicationNavData):
                // Extract and store table of contents
                self.tableOfContents = publicationNavData.getTableOfContentsAsFlatArray()

                self.updateRightBarButtonItem()
            case .failure(let error):
                self.log(error.message)
            }
        }
    }

    @objc func nextDocument() {
        readerView.next()
    }

    @objc func previousDocument() {
        readerView.previous()
    }

    /**
     Presents table of contents as page sheet
     */
    @objc func showTableOfContents() {
        let tocVC = TableOfContentsViewController(items: tableOfContents)
        tocVC.onItemSelected = { [weak self] navigationItem in
            self?.navigateTo(navigationItem: navigationItem)
        }

        tocVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = tocVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        }

        present(tocVC, animated: true, completion: nil)
    }

    /**
     Navigates to a given navigation item
     - Parameter navigationItem: navigation destination
     */
    private func navigateTo(navigationItem: NavigationItem) {
        guard let publicationLocatorUrl = publicationLocatorUrl,
              let locatorSelector = navigationItem.locatorSelector else {
            return
        }

        readerView.goTo(locator: SimpleLocatorData(sourceUrl: publicationLocatorUrl, selectors: [locatorSelector]))
    }

    // MARK: SyncMedia

    /**
     Initialises sync media player if available for the given ReaderPublication

     In this sample, we demonstrate how to create a SyncMediaTimeline from epub media overlays.
     You can also create a TTS SyncMediaTimeline. See ``ReaderPublication.createTtsSyncMediaTimeline(readerDocuments:config:progressCallback:completion:)``
     - Parameter publication: the publication for which sync media timeline is created
     */
    private func initialiseSyncMedia(publication: ReaderPublication) {
        // Check if media overlay is available
        let mediaOverlayAvailable = publication.availableSyncMediaFormats.contains(.epubMediaOverlay)
        

        guard mediaOverlayAvailable, let epubReaderPublication = publication as? EpubReaderPublication else {
            return
        }
        
        epubReaderPublication.createMediaOverlaySyncMediaTimeline(readerDocuments: epubReaderPublication.spine) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let syncMediaTimeline):
                    guard let self = self else {
                        break
                    }
                    // Show play/pause button
                    self.topControlsView.isHidden = false
                    self.playPauseButton.isHidden = false
                    //self.contentPositionTimelineSliderTrailingWithMediaButton.isActive = true
                    //self.contentPositionTimelineSliderTrailingFullWidth.isActive = false
                    self.playPauseButton.setTitle(NSLocalizedString("play_button_title", comment: "Play button title"), for: .normal)

                    // Use the reading system engine to create a SyncMediaPlayer for the given timeline
                    // The SyncMediaPlayer can be used to playback the contents of the timeline
                    self.syncMediaPlayer = self.readingSystemEngine.createSyncMediaPlayer(timeLine: syncMediaTimeline, options: SyncMediaPlayerInitOptions())
                    self.syncMediaPlayer?.addOnSyncMediaPlayerEventListener(self)

                    // Set the syncMediaPlayer on the reader view to synchronise playback with content shown in the reader view
                    self.readerView.syncMediaPlayer = self.syncMediaPlayer

                case .failure(let error):
                    self?.log(error.message)
                }
            }
        }
        
    }

    @objc func togglePlayPauseMedia() {
        guard let mediaPlayer = syncMediaPlayer else {
            return
        }

        if !mediaPlayer.paused {
            mediaPlayer.pause()
        } else {
            mediaPlayer.play()
        }
    }

    private func cleanUpSyncMedia() {
        // Destroy sync media
        if let syncMediaPlayer = syncMediaPlayer {
            readingSystemEngine.destroySyncMediaPlayer(syncMediaPlayer)
        }
        syncMediaPlayer = nil
    }

    // MARK: Content position timeline

    /**
     Creates content position timeline for a given publication
     - Parameter publication: publication used to create the content position timeline
     */
    private func createContentPositionTimeline(publication: ReaderPublication) {
        switch publication {
        case let epubReaderPublication as EpubReaderPublication:
            // EPUBs can be either re-flowable or fixed-layout (pre-paginated).
            // ContentPositionTimelineUnit.pages is only available for fixed-layout EPUBs, while ContentPositionTimelineUnit.characters is available for both re-flowable and fixed-layouts
            let options: EpubContentPositionTimelineOptions = epubReaderPublication.availableContentPositionTimelineUnits.contains { unit in
                unit == .pages
            } ? .pages() : .characters()
            epubReaderPublication.createContentPositionTimeline(readerDocuments: publication.spine, options: options) { [weak self] result in
                switch result {
                case .success(let contentPositionTimeline):
                    self?.contentPositionTimeline = contentPositionTimeline
                    self?.onCreateContentPositionTimelineCompleted(contentPositionTimeline: contentPositionTimeline)
                case .failure(let error):
                    self?.log(error.message)
                }
            }
        case let pdfReaderPublication as PdfReaderPublication:
            // PDF content position timeline always maps to page numbers
            pdfReaderPublication.createContentPositionTimeline(readerDocuments: publication.spine) { [weak self] result in
                switch result {
                case .success(let contentPositionTimeline):
                    self?.onCreateContentPositionTimelineCompleted(contentPositionTimeline: contentPositionTimeline)
                case .failure(let error):
                    self?.log(error.message)
                }
            }
        default:
            break
        }
    }

    /**
     * Handles setting up the reading position slider based on the given timeline
     */
    private func onCreateContentPositionTimelineCompleted(contentPositionTimeline: ContentPositionTimeline) {
        self.contentPositionTimeline = contentPositionTimeline
        onVisibleContentChangedListener.contentPositionTimeline = contentPositionTimeline
        pageInt = Int(self.book.lastPageIndex)
        if let locator = readerView.readingPosition {
                    contentPositionTimeline.fetchTimelinePosition(locator: locator){ [self] result in
                        switch result {
                        case .success(let value):
                            contentPositionTimelineSlider.minimumValue = 0
                            contentPositionTimelineSlider.maximumValue = Float(contentPositionTimeline.length)
                            contentPositionTimelineSlider.value = Float(value)
                            contentPositionTimelineSlider.isHidden = false
                            topControlsView.isHidden = false
                            let currentPageDouble = Double(value) / Double(contentPositionTimeline.length)
                            self.labelOfPages.text = self.book.fileType  == "pdf" ? "\(Int(self.book.lastPageIndex))" : "\(Int(currentPageDouble * 100))%"
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    contentPositionTimelineSlider.minimumValue = 0
                    contentPositionTimelineSlider.maximumValue = Float(contentPositionTimeline.length)
                    contentPositionTimelineSlider.isHidden = false
                    topControlsView.isHidden = false
                }
    }

    private func cleanUpContentPositionTimeline() {
        // Reset content position timeline
        contentPositionTimeline = nil
        onVisibleContentChangedListener.contentPositionTimeline = nil
    }

    @objc func contentPositionSliderValueDidChange() {
        contentPositionTimeline?.fetchLocator(timelinePosition: Int(contentPositionTimelineSlider.value)) { [weak self] result in
            
            switch result {
            case .success(let locator):
                self?.readerView.goTo(locator: locator)
            case .failure(let error):
                self?.log(error.message)
            }
        }
    }
}

extension ReaderEbookViewController:TtsSynthesizer{
    func addUtterance(_ utteranceData: ColibrioReader.TtsUtteranceData) {
        
    }
    
    func clearAndPause() {
        
    }
    
    func destroy() {
        
    }
    
    func initWith(callbacks: ColibrioReader.TtsSynthesizerCallbacks) {
        
    }
    
    func pause() {
        
    }
    
    func play() {
        
    }
    
    func setMuted(_ muted: Bool) {
        
    }
    
    func setPlaybackRate(_ playbackRate: Double) {
        
    }
    
    func setVolume(_ volume: Double) {
        
    }
    
    
}

/**
 OnSyncMediaPlayerEventListener implementation.
 Will be called by the SyncMediaPlayer for various events.
 */
extension ReaderEbookViewController: OnSyncMediaPlayerEventListener {
    func onSegmentFinished(event: ColibrioReader.SyncMediaEngineEventData) {
        
    }
    
    func onPlay() {
        playPauseButton.setTitle(NSLocalizedString("pause_button_title", comment: "Pause button title"), for: .normal)
    }

    func onPaused() {
        playPauseButton.setTitle(NSLocalizedString("play_button_title", comment: "Play button title"), for: .normal)
    }

    func onEndReached() {

    }

    func onError(event: SyncMediaErrorEngineEventData) {

    }

    func onReady() {

    }

    func onWaiting(event: SyncMediaWaitingEngineEventData) {

    }

    func onSeeked(event: SyncMediaEngineEventData) {

    }

    func onSeeking(event: SyncMediaEngineEventData) {

    }

    func onSegmentActive(event: SyncMediaSegmentActiveEngineEventData) {

    }

    func onSegmentDurationChanged(event: SyncMediaSegmentDurationChangedEngineEventData) {

    }

    func onTimelinePositionChanged(timelinePositionData: SyncMediaTimelinePositionData, approximateElapsedTimeMs: Int) {

    }

    func onReaderViewSynchronizationStateChanged(state: SyncMediaReaderViewSynchronizationStateData) {

    }
}

class FontStylePanelLayout:FloatingPanelLayout{
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 72.0, edge: .top, referenceGuide: .superview),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .superview),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: UIDevice.isIPad ? UIScreen.maxHeight * 0.25 : UIScreen.maxHeight * 0.275, edge: .bottom, referenceGuide: .superview),
        ]
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state {
            case .full, .half,.tip: return 0.325
            default: return 0.0
            }
        }
}
class IntrinsicPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .superview),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .superview),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: UIDevice.isIPad ? UIScreen.maxHeight * 0.1975 : UIScreen.maxHeight * 0.275, edge: .bottom, referenceGuide: .superview),
        ]
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state {
            case .full, .half,.tip: return 0.325
            default: return 0.0
            }
        }
}

class FootnoteLandscapePanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .superview),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .superview),
            
        ]
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            switch state {
            case .full, .half,.tip: return 0.325
            default: return 0.0
            }
        }
}
