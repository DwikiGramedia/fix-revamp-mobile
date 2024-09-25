//
//  FootnoteViewController.swift
//  SCOOP
//
//  Created by Gramedia on 24/02/23.
//

import UIKit
import SnapKit
import ColibrioReader

class FootnoteViewController: UIViewController {
    
    private var readingSystemEngine: ReadingSystemEngine!
    private var colibrioView: ColibrioView = ColibrioView()
    private var titleFootnote:UILabel = {
        let label = UILabel()
        label.font  = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private var valueFootnote:UILabel = {
        let label = UILabel()
        label.font  = .systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private var footnoteValue:String = ""
    
    var indexSpine:Int
    var locator:SimpleLocatorData
    var urlFile:URL
    
    init(indexSpine: Int, locator: SimpleLocatorData, urlFile: URL) {

        self.indexSpine = indexSpine
        self.locator = locator
        self.urlFile = urlFile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        onDocumentPicked(url: urlFile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        colibrioView.setAllowedCalloutActions([CalloutAction.custom("Wohoo")])
        readingSystemEngine = colibrioView.getReadingSystemEngine()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        
        view.addSubview(titleFootnote)
        titleFootnote.snp.makeConstraints{ make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.snp.top).offset(24)
        }
        titleFootnote.text = "Footnote "
        
        view.addSubview(colibrioView)
        colibrioView.isUserInteractionEnabled = false
        
        colibrioView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleFootnote.snp.bottom).offset(12)
            make.height.equalTo(UIDevice.current.orientation == UIDeviceOrientation.landscapeRight || UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ? UIScreen.maxHeight * 0.25 : UIScreen.maxHeight * 0.2)
        }
    }
    
    private func onDocumentPicked(url: URL) {
        
            if let fileChannelDataSource = getPublicationUrlDataSource(publicationUrl: url) {
                let readingSessionOptions = ReadingSessionOptions(publicationToken: getPublicationToken(publicationUrl: url), userToken: getUserToken())
                switch url.getPublicationType() {
                case .epub:
                    loadEpub(fileChannelDataSource: fileChannelDataSource, readingSessionOptions: readingSessionOptions)
                case .pdf:
                    print("pdf")
                    loadPDF(fileChannelDataSource: fileChannelDataSource, readingSessionOptions: readingSessionOptions)
                default:
                    print("error")
//                    showMessage(NSLocalizedString("error_unsupported_file", comment: "File not supported error message"))
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
     Gets unique token representing the publication. This can for example be a sha hash of the publication file or an ID of the publication in the system.
     Refer to the cloud license setup page at https://learn.colibrio.com/guide/3.0/License%20setup/Cloud-License-Setup.html
     */
    private func getPublicationToken(publicationUrl: URL) -> String {
        // TODO: write logic for getting publication token
        return "dummy publication token"
    }

    /**
     Gets unique token representing the user. This can for example be a sha hash of the user ID in the system.
     Refer to the cloud license setup page at https://learn.colibrio.com/guide/3.0/License%20setup/Cloud-License-Setup.html
     */
    private func getUserToken() -> String {
        // TODO: write logic for getting user token
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int else {
            return ""
        }
        return "\(email)\(userId)".sha256()
    }

    /**
     Loads epub publication using the given data source and reading session options
     - Parameters:
       - fileChannelDataSource: a random access data source
       - readingSessionOptions: reading session options
     */
    private func loadEpub(fileChannelDataSource: RandomAccessDataSource, readingSessionOptions: ReadingSessionOptions) {
        cleanUp()
        
        var epubReaderPublicationOptions = EpubReaderPublicationOptions()
        epubReaderPublicationOptions.fixedLayoutStyleOptions.allowFontSetCustomization = true
        
        epubReaderPublicationOptions.customPublicationCss.injectionPointStart.append(
            """
                * {
                  user-select: none;
                  -webkit-user-select: none;
                  -webkit-touch-callout: none;
                }
            """
        )
        
        epubReaderPublicationOptions.clipboardOptions = ReaderPublicationClipboardOptions(allowCopy: false,textToPrependOnCopy: "", textToAppendOnCopy: "")
        epubReaderPublicationOptions.preventDefaultContextMenu = true
        
        let epubPublicationConfig = EpubRandomAccessDataSourceLoadConfig(publicationDataSource: fileChannelDataSource,
                readingSessionOptions: readingSessionOptions, readerPublicationOptions: epubReaderPublicationOptions)
       
        
        
        readingSystemEngine.loadEpub(config: epubPublicationConfig) { [weak self] (result) in
            print(result)
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
        
        let pdfPublicationOptions = PdfPublicationOptions()
        
        var pdfReaderPublicationOptions = PdfReaderPublicationOptions()
        
        pdfReaderPublicationOptions.highResScaleThreshold = 1
        pdfReaderPublicationOptions.clipboardOptions = ReaderPublicationClipboardOptions(allowCopy: false,textToPrependOnCopy: "", textToAppendOnCopy: "")
        pdfReaderPublicationOptions.preventDefaultContextMenu = true
        let pdfPublicationConfig = PdfRandomAccessDataSourceLoadConfig(publicationDataSource: fileChannelDataSource,
                readingSessionOptions: readingSessionOptions, readerPublicationOptions: pdfReaderPublicationOptions, publicationOptions: pdfPublicationOptions)
        readingSystemEngine.loadPdf(config: pdfPublicationConfig) { [weak self] (result) in
            switch result {
            case .success(let publication):
                print(publication.sourcePublication.preferredFlowMode)
                self?.onPublicationLoaded(publication)
            case .failure(let error):
                print(error)
                self?.onPublicationLoadingError(error)
            }
        }
    }
    

    /**
     Initialises renderers and adds them to a given view
     - Parameters:
       - readerView: owner of the created renderers
       - shouldIgnoreAspectRatio: applies to all renderers
     */
    private func createRenderers(for readerView: ReaderView, shouldIgnoreAspectRatio: Bool) {
        let renderer = StackRenderer(with: StackRendererOptions(ignoreAspectRatio: shouldIgnoreAspectRatio))
//        let renderer = SinglePageSwipeRenderer(with: SinglePageSwipeRendererOptions(direction:.y,ignoreAspectRatio: true))
        
        try? readerView.addRenderer(renderer, mediaQueryRule: nil)
    }

    /**
     Given a reader publication, initialises the reader view with the document and renderers.
     Then initiates fetching navigation data, and initialises sync media.
     - Parameter publication: the reader publication
     */
    private func onPublicationLoaded(_ publication: ReaderPublication) {
        // Store publication base locator url
        //publicationLocatorUrl = publication.defaultLocatorUrl
        

        let readerView = readingSystemEngine.readerView
      

        let shouldIgnoreAspectRatio = publication.sourcePublication.defaultLayout == ContentDocumentLayout.reflowable
        createRenderers(for: readerView, shouldIgnoreAspectRatio: shouldIgnoreAspectRatio)
        
        
        
        readerView.readerDocuments = publication.spine
        readerView.options.publicationStyleOptions.fontSizeScaleFactor = 1.5
//
//        publication.getContentLocation(locator: locator).contentResolver.fetchTextContentAfter(textLength:120){
//            result in
//            switch result {
//            case .success(let footnote):
//                print(footnote)
//                self.valueFootnote.text = footnote
//                self.footnoteValue = footnote
//            case .failure(let error):
//                print(error.message)
//                print(error.namespace)
//            }
//        }
//
        readerView.goTo(locator: locator){ result in
            switch result{
            case .success(_):
                print("Success")
                var annotationLayer = readerView.createAnnotationLayer()
                annotationLayer.visible = true
                 annotationLayer.options = ReaderViewAnnotationLayerOptions(layerStyle: ["foreground-color": "#b3b300"])
//                 annotationLayer.defaultAnnotationOptions = ReaderViewAnnotationOptions(rangeStyle: ["background-color": "#EADDCA"])
                do{
                    var dataAnnotation = try annotationLayer.createAnnotation(locator: self.locator, customData: nil)
                    
                }catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func onPublicationLoadingError(_ error: ColibrioReaderResponseError) {
        // Hide play pause button
        //playPauseButton.isHidden = true

        // Hide toc button
        navigationItem.setRightBarButton(nil, animated: true)

        // Show error message
//        showMessage(NSLocalizedString("error_publication_loading", comment: "Publication loading error message"))
        log(error.message)
    }
    
    private func cleanUp() {



        // Remove reader documents
        let readerView = readingSystemEngine.readerView
        readerView.readerDocuments = []

        // Unload publication
        readingSystemEngine.readerPublications.forEach { publication in
            try! readingSystemEngine.unloadPublication(publication)
        }
    }
    
    
    
    @objc private func closeFootnote(){
        self.dismiss(animated: true)
    }
}
