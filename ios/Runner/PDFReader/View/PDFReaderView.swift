//
//  PDFReaderView.swift
//  SCOOP
//
//  Created by Gramedia on 11/01/23.
//

import Foundation
import PDFKit
import SnapKit
import FloatingPanel
import ScreenshotPreventing

class PDFReaderView:UIViewController,FloatingPanelControllerDelegate{
    
    var url:URL
    var book:Book
    var pdfView:PDFReader!
    
    var isBookmark:Bool = false
    var isOpenList:Bool = false
    var isHideBar:Bool = false
    var indexPage:Int = 0
    var floatingPanel:FloatingPanelController!
    var pdfDocument:PDFDocument!
    
    var openMenuButton: UIButton!
    var closeMenuButton: UIButton!
    var bookmarkButton: UIButton!
    var unbookmarkButton: UIButton!
    var contentMenu: ContentMenuViewController!
    var slider:UISlider!
    var hideTimeduration:Double = 0.0
    private lazy var container = ScreenshotPreventingView(contentView: pdfView)

    var numberPageIndicatorLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .center
        return label
    }()
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
    
    var date:Date?
    var timer:Timer?
    var interactor:PDFReaderInteractor?
    
    var pageViews:[Pageview] = []
    var pageViewEpp:[PageViewEpp] = []
    var timeDuration:Double = 0.0
    let viewData =  UIView()
    let viewNavigation =  UIView()
    
    
    init(url: URL,book:Book) {
        self.url = url
        self.book = book
        super.init(nibName: nil, bundle: nil)
        PDFReaderConfigurator.configurator(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        firstTimeVisitReader()
        self.date = Date()
        //AppUtility.lockOrientation(.portrait,andRotateTo: .landscapeLeft)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if let currentPage: PDFPage = pdfView.currentPage, let pageIndex: Int = pdfView.document?.index(for: currentPage){
            timer?.invalidate()
            BookManagerService().updateLastHistoryPDF(book: book, history: "\(pageIndex)")
            interactor?.postEppRecord(body: RecordParameterEpp(pageviews: pageViewEpp))
        }
        super.viewWillDisappear(true)
        //AppUtility.lockOrientation(.portrait)
        //resetToPortrait()
    }
                    
    override func viewDidLoad() {
        pdfView = PDFReader(frame: .zero)
        pdfDocument = PDFDocument(url: url)
        pdfDocument.unlock(withPassword: book.key ?? "")
        pdfView.document = pdfDocument
        pdfView.displayMode = .singlePage
        pdfView.displaysRTL = false
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        pdfView.displaysAsBook = true
        pdfView.displayDirection = .horizontal

        pdfView.autoresizingMask = [.flexibleHeight,.flexibleWidth,.flexibleBottomMargin]
       
        
        
        setupView()
        
        goToHistory()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        NotificationCenter.default.addObserver(
            self,
              selector: #selector(handlePageChange(notification:)),
            name: Notification.Name.PDFViewPageChanged,
              object: nil)
        
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            self.showMessage("Tidak bisa foto", "Tidak diperbolehkan mengambil foto buku")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .PDFViewPageChanged, object: nil)
        
    }
    
    func firstTimeVisitReader() {
        let isFirstVisited = UserDefaults.standard.value(forKey: "firstTimeVisitReader") as? Bool ?? true
        if isFirstVisited == true {
            
            self.showMessageWithOptionDialog("Content Information", "It is not permitted to take pictures or screenshots of the content being read", callbackYes: { [self] in
                UserDefaults.standard.setValue(false, forKey: "firstTimeVisitReader")
                dismiss(animated: true)
            }, callbackNo: { [self] in
                navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private func goToHistory(){
        if book.lastUpdatePath != nil {
            var index = Int( book.lastUpdatePath ?? "") ?? 0
            var pdfPage = (pdfView.document?.page(at: index))!
            indexPage = index
            slider.value = Float(indexPage)
            pdfView.go(to: pdfPage )
            numberPageIndicatorLabel.text = "Page \(indexPage + 1) of \(pdfView.document?.pageCount ?? 0) (\(String(format: "%.0f", ((Double(indexPage + 1) / Double(pdfView.document?.pageCount ?? 0)) * 100).roundToDecimal(0)))%)"
        } else {
            indexPage = 0
            var pdfPage = (pdfView.document?.page(at: 0))!
            pdfView.go(to: pdfPage)
            numberPageIndicatorLabel.text = "Page \(indexPage + 1) of \(pdfView.document?.pageCount ?? 0) (\(String(format: "%.0f", ((Double(indexPage + 1) / Double(pdfView.document?.pageCount ?? 0)) * 100).roundToDecimal(0)))%)"
        }
        
    }
    
    private func setupView(){
        floatingPanel = FloatingPanelController(delegate: self)
        
        contentMenu = ContentMenuViewController(book: book)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTopandBottombar))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        //container.setup(contentView: pdfView)
        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(24)
        }

        //viewData.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        viewData.backgroundColor = .clear
        
        let previousButton = createButton(title: "chevron.left")
        previousButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        
        let nextButton = createButton(title: "chevron.right")
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        slider = UISlider()
        slider.maximumValue = Float(pdfView.document?.pageCount  ?? 0 ) - 1.0
        slider.isUserInteractionEnabled = true
        print("Jumlah halaman \(pdfView.document?.pageCount ?? 0)")
        
        slider.addTarget(self, action: #selector(self.valueChangePage), for: .valueChanged)
        
        view.addSubview(viewData)
        viewData.backgroundColor = .white
        viewData.snp.makeConstraints{ make in
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(UIScreen.maxHeight * 0.15)
            make.right.equalTo(view.snp.right)
        }
        
        viewData.addSubview(previousButton)
        previousButton.snp.makeConstraints{ make in
            make.left.equalTo(viewData.snp.left).offset(UIScreen.maxWidth * 0.1)
            make.bottom.equalTo(viewData.snp.bottom).offset(-24)

        }
        
        viewData.addSubview(nextButton)
        nextButton.snp.makeConstraints{ make in
            make.right.equalTo(viewData.snp.right).offset(-UIScreen.maxWidth * 0.1)
            make.bottom.equalTo(viewData.snp.bottom).offset(-24)
            
        }
        viewData.addSubview(slider)
        
        
        viewData.addSubview(numberPageIndicatorLabel)
        numberPageIndicatorLabel.snp.makeConstraints{ make in
            make.left.right.equalTo(viewData)
            make.bottom.equalTo(slider.snp.top).offset(-4)
            make.top.equalTo(viewData.snp.top).offset(8)
        }
        
        slider.snp.makeConstraints{ make in
            make.left.equalTo(previousButton.snp.right).offset(16)
            make.right.equalTo(nextButton.snp.left).offset(-16)
            make.bottom.equalTo(viewData.snp.bottom).offset(-24)
        }
        
        viewNavigation.backgroundColor = .white
        view.addSubview(viewNavigation)
        
        pdfView.addSubview(watermarkLabel)
        pdfView.addSubview(watermarkLabel2)
        pdfView.addSubview(watermarkLabel3)
        pdfView.addSubview(watermarkLabel4)
        watermarkLabel.snp.makeConstraints{ make in
            make.left.equalTo(pdfView).offset(UIScreen.maxWidth / 4)
            
            make.top.equalTo(pdfView.snp.top).offset(UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        
        watermarkLabel2.snp.makeConstraints{ make in
            make.left.equalTo(pdfView).offset(UIScreen.maxWidth / 4)
            
            make.bottom.equalTo(pdfView.snp.bottom).offset(-UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        watermarkLabel3.snp.makeConstraints{ make in
            //make.left.equalTo(watermarkLabel.snp.right)
            make.right.equalTo(pdfView.snp.right).offset(-UIScreen.maxWidth / 4)
            make.top.equalTo(pdfView.snp.top).offset(UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        watermarkLabel4.snp.makeConstraints{ make in
            //make.left.equalTo(watermarkLabel2.snp.right)
            make.right.equalTo(pdfView.snp.right).offset(-UIScreen.maxWidth / 4)
            make.bottom.equalTo(pdfView.snp.bottom).offset(-UIScreen.maxHeight / 2.5)
            make.width.equalTo(UIScreen.maxWidth / 2)
        }
        
        viewNavigation.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(UIScreen.maxHeight >= 1024.0 ? UIScreen.maxHeight * 0.075  :UIScreen.maxHeight * 0.125)
            //make.width.equalTo(UIScreen.maxWidth)
        }
        
        openMenuButton = UIButton()
        openMenuButton.setImage(UIImage(named: "bookmarkList"), for: .normal)
        openMenuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        viewNavigation.addSubview(openMenuButton)
        openMenuButton.snp.makeConstraints{ make in
            make.right.equalTo(viewNavigation.snp.right).offset(UIDevice.current.userInterfaceIdiom == .pad ? -24 : -16)
            //make.top.equalTo(viewNavigation.snp.top)
            make.bottom.equalTo(viewNavigation.snp.bottom).offset(-16)
        }
        
        closeMenuButton = UIButton()
        //closeMenuButton.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        //closeMenuButton.titleLabel?.text = "Close"
        closeMenuButton.setTitle("Close", for: .normal)
        closeMenuButton.titleLabel?.textColor = .blue
        closeMenuButton.titleLabel?.font = .systemFont(ofSize: 13)
        closeMenuButton.setTitleColor(.blue, for: .normal)
        closeMenuButton.tintColor = .blue

        
        closeMenuButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        viewNavigation.addSubview(closeMenuButton)
        closeMenuButton.snp.makeConstraints{ make in
            
            make.right.equalTo(viewNavigation.snp.right).offset(UIDevice.current.userInterfaceIdiom == .pad ? -12 : -4)
            make.bottom.equalTo(viewNavigation.snp.bottom).offset(UIDevice.current.userInterfaceIdiom == .pad ? -13 : -12)
            make.width.equalTo(40)
        }
        
        setupBooklist()

        bookmarkButton = UIButton()
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmark), for: .touchUpInside)
        viewNavigation.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints{ make in
            make.right.equalTo(viewNavigation.snp.right).offset( UIDevice.current.userInterfaceIdiom == .pad ? -UIScreen.maxWidth * 0.075 : -UIScreen.maxWidth * 0.15)
            make.bottom.equalTo(viewNavigation.snp.bottom).offset(-16)
        }

        unbookmarkButton = UIButton()
        unbookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        unbookmarkButton.addTarget(self, action: #selector(unBookmark), for: .touchUpInside)
        viewNavigation.addSubview(unbookmarkButton)
        unbookmarkButton.snp.makeConstraints{ make in
            make.right.equalTo(viewNavigation.snp.right).offset(UIDevice.current.userInterfaceIdiom == .pad ? -UIScreen.maxWidth * 0.075 : -UIScreen.maxWidth * 0.15)
            make.bottom.equalTo(viewNavigation.snp.bottom).offset(-16)
        }
        setupNavigation()
        numberPageIndicatorLabel.textColor = .black
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backNavigation), for: .touchUpInside)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .blue
        backButton.setTitleColor(.blue, for: .normal)
        backButton.centerTextAndImage(spacing: 8)
        viewNavigation.addSubview(backButton)
        backButton.snp.makeConstraints{ make in
            make.left.equalTo(viewNavigation.snp.left).offset(16)
            make.bottom.equalTo(viewNavigation.snp.bottom).offset(-16)
        }
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
        let changePosition = Int.random(in: 0...3)
        watermark(email: email, date: "\(day)\(month)\(year)", changePosition: changePosition)
        
    }
    
    @objc private func hideTopandBottombar(){
        self.isHideBar.toggle()
        hideBottomAndTopbar()
        self.hideTimeduration = 0.0
        print(timeDuration)
    }
    
    private func setupNavigation(){
        guard let pageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return  }
        isBookmark = book.bookmarkArray.filter({ $0.page == pageIndex}).isEmpty
        if isBookmark {
            bookmarkButton.isHidden = false
            bookmarkButton.isEnabled = true
            unbookmarkButton.isHidden = true
            unbookmarkButton.isEnabled = false
        } else {
            bookmarkButton.isHidden = true
            bookmarkButton.isEnabled = false
            unbookmarkButton.isHidden = false
            unbookmarkButton.isEnabled = true
        }
    }
    
    private func setupBooklist(){
        if isOpenList == true {
            openMenuButton.isHidden = true
            openMenuButton.isEnabled = false
            closeMenuButton.isHidden = false
            closeMenuButton.isEnabled = true
        } else {
            openMenuButton.isHidden = false
            openMenuButton.isEnabled = true
            closeMenuButton.isHidden = true
            closeMenuButton.isEnabled = false
        }
    }
    
    private func hideBottomAndTopbar(){
        if self.viewNavigation.isHidden == false {
            isHideBar = true
            self.viewNavigation.isHidden = true
            self.viewData.isHidden = true
        } else {
            isHideBar = false
            self.viewNavigation.isHidden = false
            self.viewData.isHidden = false
        }
    }
    
    @objc private func updateTimer(){
        self.timeDuration += 0.1
        self.hideTimeduration += 0.1
        if self.hideTimeduration > 10.0 {
            self.viewNavigation.isHidden = true
            self.viewData.isHidden = true
            isHideBar = true
        }
        
    }
    
    @objc private func previousPage(sender:Any){
        if pdfView.canGoToPreviousPage {
            guard let pageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return  }
            slider.value = Float(pageIndex) - 1
            pdfView.goToPreviousPage(sender)
        }
    }
    
    @objc private func nextPage(sender:Any){
        if pdfView.canGoToNextPage{
            guard let pageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return  }
            slider.value = Float(pageIndex) + 1
            pdfView.goToNextPage(sender)
        }
    }
    
    @objc  func valueChangePage(){
        print(slider.value)
        guard  slider.value < Float(pdfView.document?.pageCount ?? 0) - 1.0 else {
            return
        }
        pdfView.go(to: (pdfView.document?.page(at: Int(slider.value))!)!)

    }
    
    @objc private func bookmark(){
        
        guard let pageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return  }
        BookManagerService().addBookmark(book: book, history: nil, page: pageIndex )
        isBookmark = checkIsAvalaibleBookmark(pageIndex: pageIndex )
        contentMenu.reload()
        setupNavigation()
    }
    
    @objc private func unBookmark(){
        guard let pageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return  }
        let bookmark = fetchBookmark(pageIndex: pageIndex)
        book.removeFromBookmarks(bookmark!)
        contentMenu.reload()
        isBookmark = checkIsAvalaibleBookmark(pageIndex: pageIndex)
        setupNavigation()
    }
    
    @objc private func openMenu(){
        print("Hallo")
        isOpenList.toggle()
        setupBooklist()

        contentMenu.delegate = self
        floatingPanel.set(contentViewController: contentMenu)
        present(floatingPanel, animated: true)
    }
    
    @objc private func closeMenu(){
        isOpenList.toggle()
        setupBooklist()
        self.dismiss(animated: true)
    }
    
    @objc private func backNavigation(){
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchBookmark(pageIndex:Int)-> Bookmark?{
        var bookmark = book.bookmarkArray.filter({$0.page == Int32(pageIndex)})
        return bookmark.first
    }
    
    private func checkIsAvalaibleBookmark(pageIndex:Int) -> Bool {
        var bookmark = book.bookmarkArray.filter({$0.page == Int16(pageIndex)}).isEmpty
        return bookmark
    }
    

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false
    }
    
    
}

class PDFReader:PDFView{

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        self.currentSelection = nil
        self.clearSelection()
        return false
    }
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
            if gestureRecognizer is UILongPressGestureRecognizer {
                gestureRecognizer.isEnabled = false
            }

            super.addGestureRecognizer(gestureRecognizer)
        }
    override func buildMenu(with builder: UIMenuBuilder) {
        builder.remove(menu: .share)
        builder.remove(menu: .lookup)
    }
    
}

extension PDFReaderView:ContentMenuDelegate{
    func goingToBookMark(bookMark: Bookmark) {
        pdfView.go(to: pdfDocument.page(at: Int(bookMark.page - 1))!)
    }
    
    func reload(tableView: UITableView) {
        tableView.reloadData()
    }

}



extension PDFReaderView{
    @objc  func handlePageChange(notification: Notification)
    {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int, let clientId = UserDefaults.standard.value(forKey: "clientId") as? Int,  let catalogId = UserDefaults.standard.value(forKey: "catalogId") as? Int, let borrowedId = UserDefaults.standard.value(forKey: "borrowedId") as? Int, let orgId = UserDefaults.standard.value(forKey: "organizationId")as? Int else {
                            return
                        }
        if let currentPage: PDFPage = pdfView.currentPage, let pageIndex: Int = pdfView.document?.index(for: currentPage) {
            indexPage = pageIndex
            slider.value = Float(pageIndex)
            setupNavigation()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = dateFormatter.string(from: self.date ?? Date())
            if timeDuration > 3.00 {
                let pageEpp = PageViewEpp(borrowing_id: borrowedId, item_id:  Int(self.book.productId), page_orientation: "Potrait", duration: timeDuration, max_duration: 0, online_status: "online", page_number: [pageIndex], chapter: "", start_time: "\(dateString)+0000", end_time: "\(dateString)+0000", device_id: UIDevice.current.identifierForVendor?.uuidString ?? "", device_model:  UIDevice.current.model, os_version: UIDevice.current.systemVersion, client_version: "3.0.2", client_id: clientId, ip_address: "192.168.0.1", datetime: "\(dateString)+0000", user_id: userId, session_name: "\(dateString)\(String(describing: UIDevice.deviceId))".sha256(), catalog_id: catalogId, organization_id: orgId)
                self.pageViewEpp.append(pageEpp)
                timeDuration = 0.0
                indexPage = pageIndex
            }
            numberPageIndicatorLabel.textColor = .black
            numberPageIndicatorLabel.text = "Page \(pageIndex + 1) of \(pdfView.document?.pageCount ?? 0) (\(String(format: "%.0f", ((Double(pageIndex + 1) / Double(pdfView.document?.pageCount ?? 0)) * 100).roundToDecimal(0)))%)"
            
        }
        timeDuration = 0.0
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id")
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: self.date ?? Date())
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: self.date ?? Date())
        dateFormatter.dateFormat = "yy"
        let year = dateFormatter.string(from: self.date ?? Date())
        let changePosition = Int.random(in: 0...3)
        watermark(email: email, date: "\(day)\(month)\(year)", changePosition: changePosition)
        
    }
    
    func watermark(email:String,date:String,changePosition:Int){
        let watermarkText:String = "\(book.watermark ?? "")i" //"\(email)/\(date)/\(book.watermark ?? "")i"
        
        watermarkLabel.text = watermarkText
        watermarkLabel2.text = watermarkText
        watermarkLabel3.text = watermarkText
        watermarkLabel4.text = watermarkText

        watermarkLabel.transform  = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        watermarkLabel2.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        watermarkLabel3.transform =  CGAffineTransform(rotationAngle:  CGFloat.pi + CGFloat.pi / 4).concatenating(CGAffineTransform(scaleX: -1, y: -1))
        watermarkLabel4.transform =  CGAffineTransform(rotationAngle: CGFloat.pi - CGFloat.pi / 4 ).concatenating(CGAffineTransform(scaleX: -1, y: -1))

        switch changePosition{
        case 0:
            watermarkLabel.isHidden = false
            watermarkLabel2.isHidden = true
            watermarkLabel3.isHidden = true
            watermarkLabel4.isHidden = true
        case 1:
            watermarkLabel.isHidden = true
            watermarkLabel2.isHidden = false
            watermarkLabel3.isHidden = true
            watermarkLabel4.isHidden = true
        case 2 :
            watermarkLabel.isHidden = true
            watermarkLabel2.isHidden = true
            watermarkLabel3.isHidden = false
            watermarkLabel4.isHidden = true
        default:
            watermarkLabel.isHidden = true
            watermarkLabel2.isHidden = true
            watermarkLabel3.isHidden = true
            watermarkLabel4.isHidden = false
        }
    }
}

extension PDFReaderView: PDFReaderPresenterOutput{
    func getRecord(response: RecordResponse) {
        print(response)
    }
    
    func getMessage(error: String) {
        print(error)
    }
    
}
