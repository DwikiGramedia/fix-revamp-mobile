//
//  Ext-ReaderEbookViewController.swift
//  SCOOP
//
//  Created by Chondro on 19/05/23.
//

import Foundation
import ColibrioReader
import UIKit

import CoreData
import Toast

extension ReaderEbookViewController:ChangedPageDelegate{
    
    func changePage(page: ColibrioReader.SimpleLocatorData, index: Int) {
        self.pageInt = index
        
        if let position = book.fileType == "pdf" ? readingSystemEngine.readerView.visibleRange : readingSystemEngine.readerView.readingPosition {
            isBookmarkApprove(page: index, locator: position)
            if isBookmark == false {
                updateRightBarButtonItem()
            } else {
                updateRightBarButtonItem()
            }
        }
        self.labelOfPages.text = book.fileType == "pdf" ? "Page \(Int(index)) of \(Int(contentPositionTimelineSlider.maximumValue)) (\(Int(((Double(index) / Double(contentPositionTimelineSlider.maximumValue)) * 100).roundToDecimal(0)))%)" : "\(Int((Double(Double(index) / Double(Int(contentPositionTimelineSlider.maximumValue))) * 100).roundToDecimal(0)))%"
        
        let readerView = readingSystemEngine.readerView
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,let userId = UserDefaults.standard.value(forKey: "user_id") as? Int, let clientId = UserDefaults.standard.value(forKey: "clientId") as? Int,  let catalogId = UserDefaults.standard.value(forKey: "catalogId") as? Int, let borrowedId = UserDefaults.standard.value(forKey: "borrowedId") as? Int, let orgId = UserDefaults.standard.value(forKey: "organizationId")as? Int else {
                            return
                        }
        let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = dateFormatter.string(from: self.date ?? Date())
        let pageEpp = PageViewEpp(borrowing_id: borrowedId, item_id:  Int(self.book.productId), page_orientation: UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ? "Landscape" : "Potrait", duration: timeDuration, max_duration: 0, online_status: NetworkMonitorObserver.isConnected ? "Online" : "Offline", page_number: [pageInt], chapter: "", start_time: "\(dateString)+0000", end_time: "\(dateString)+0000", device_id: UIDevice.current.identifierForVendor?.uuidString ?? "", device_model:  UIDevice.current.model, os_version: UIDevice.current.systemVersion, client_version: "3.0.4", client_id: clientId, ip_address: "192.168.0.1", datetime: "\(dateString)+0000", user_id: userId, session_name: "\(dateString)\(String(describing: UIDevice.deviceId))".sha256(), catalog_id: catalogId, organization_id: orgId)
        interactor?.postPage(page: pageEpp)
        self.timeDuration = 0.0
        self.timeDuration = 0.0
        self.pageInt = index
        //let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id")
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: self.date ?? Date())
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: self.date ?? Date())
        dateFormatter.dateFormat = "yy"
        let year = dateFormatter.string(from: self.date ?? Date())
        let randomPosition = Int.random(in: 0...3)
        watermark(email: email, date: "\(day)\(month)\(year)", changePosition: randomPosition)
    }
    
    func watermark(email:String,date:String,changePosition:Int){
        watermarkLabel.text = "\(book.watermark ?? "")i"
        watermarkLabel2.text = "\(book.watermark ?? "")i"
        watermarkLabel3.text = "\(book.watermark ?? "")i"
        watermarkLabel4.text = "\(book.watermark ?? "")i"

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

extension ReaderEbookViewController:SettingReaderDelegate{
    func setSwipeDirection(renderer: ColibrioReader.Renderer) {
        do{
            try readingSystemEngine.readerView.addRenderer(renderer)
            try readingSystemEngine.readerView.setActiveRenderer(renderer)
        }catch {
            print(error)
        }
    }
    
    func setThemeReader(data: ColibrioReader.PublicationStylePalette?) {
        readingSystemEngine.readerView.options.publicationStyleOptions.palette = data
    }
    
    func setMarginHorizontal(value: Double) {
        readingSystemEngine.readerView.options.publicationStyleOptions.pageMargins?.left.value = value
        readingSystemEngine.readerView.options.publicationStyleOptions.pageMargins?.right.value = value
    }
    
    func setMarginVertical(value: Double) {
        readingSystemEngine.readerView.options.publicationStyleOptions.pageMargins?.top.value = value
        readingSystemEngine.readerView.options.publicationStyleOptions.pageMargins?.bottom.value = value
    }
    
    func setLineHeight(value: Double) {
        readingSystemEngine.readerView.options.publicationStyleOptions.lineHeightScaleFactor = value
    }
    
    func setFontSize(scale: Double) {
        readingSystemEngine.readerView.options.publicationStyleOptions.fontSizeScaleFactor = scale
    }
    
    func setFontFamily(family: PublicationStyleFontSet) {
        do{
            if let mainBundle = Bundle.main.url(forResource: family.fontFaces.first?.src ?? "", withExtension: nil) {
                let encodeString = try Data(contentsOf: mainBundle)
                readingSystemEngine.readerView.options.publicationStyleOptions.fontSet = PublicationStyleFontSet(defaults: family.defaults, fontFaces: [
                    PublicationStyleFontFace(family: family.fontFaces.first?.family ?? "", mediaType: .fontTtf, src: encodeString.base64EncodedString())
                ])
            } else {
                readingSystemEngine.readerView.options.publicationStyleOptions.fontSet = nil
            }
           
            
            
        }catch {
            
        }
    }
    
    func setAlignment(alignment: PublicationStyleTextAlignmentOptions?) {
        readingSystemEngine.readerView.options.publicationStyleOptions.textAlignment = alignment
    }
    
    func styleReaderConfigure(){
        let dataArray:[PublicationStylePalette?] = ListDataReader.init().dataTheme
        
        let listFontFamily:[FontFamilyStyle] = ListDataReader.init().dataFontFamily
        
        let listSwipeDirection:[ColibrioReader.Renderer] = ListDataReader.init().dataSwipeDirection
        
        let listAlignment:[ColibrioReader.PublicationStyleTextAlignmentOptions?] = ListDataReader.init().dataAlignment
        
        let fontSize = Double(Double(Int(book.fontSize)) / 100.00)
        let lineHeightSize = Double(Double(Int(book.lineHeightSize <=  70 ? 100 : book.lineHeightSize)) / 100.00)
        let indexTheme = Int(book.indexTheme )
        let indexSwipeDirection = Int(book.indexSwipeDirection )
        let indexFontFamily = Int(book.indexFontFamily)
        let indexAlignmet = Int(book.indexAlignment)
      
        readingSystemEngine.readerView.options.publicationStyleOptions.fontSizeScaleFactor = fontSize
        readingSystemEngine.readerView.options.publicationStyleOptions.lineHeightScaleFactor = lineHeightSize
        print(readingSystemEngine.readerView.options.publicationStyleOptions.lineHeightScaleFactor)
        readingSystemEngine.readerView.options.publicationStyleOptions.palette = dataArray[indexTheme]
        readingSystemEngine.readerView.options.publicationStyleOptions.textAlignment = listAlignment[indexAlignmet]
        
        readingSystemEngine.readerView.options.publicationStyleOptions.fontSet = listFontFamily[indexFontFamily].fontSet

        do{
            try readingSystemEngine.readerView.addRenderer(listSwipeDirection[indexSwipeDirection])
            
            
            if let mainBundle = Bundle.main.url(forResource: listFontFamily[indexFontFamily].fontSet.fontFaces.first?.src ?? "", withExtension: nil){
                print(mainBundle.absoluteString)
                let encodeString = try Data(contentsOf: mainBundle)
                readingSystemEngine.readerView.options.publicationStyleOptions.fontSet = PublicationStyleFontSet(defaults: listFontFamily[indexFontFamily].fontSet.defaults, fontFaces: [
                    PublicationStyleFontFace(family: listFontFamily[indexFontFamily].fontSet.fontFaces.first?.family ?? "", mediaType: .fontTtf, src: encodeString.base64EncodedString())
                ])
            } else {
                readingSystemEngine.readerView.options.publicationStyleOptions.fontSet = nil
            }
            
            try readingSystemEngine.readerView.setActiveRenderer(listSwipeDirection[indexSwipeDirection])
        } catch {
            print(error)
        }
        
    }
}

extension ReaderEbookViewController :OnMouseEventListener{
    func onClick(event: MouseEngineEventData) {
        isHiddenTopandBottom.toggle()
        self.hideTimeDuration = 0.0
        if self.isHiddenTopandBottom == true {
            self.navigationController?.navigationBar.isHidden = true
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationItem.leftBarButtonItems = nil
            bottomControlsView.isHidden = true
            topControlsView.isHidden = true
            readingSystemEngine.readerView.allowedGestureTypes = [.panZoom,.swipeNavigation]
        } else {
            self.navigationController?.navigationBar.isHidden = false
            bottomControlsView.isHidden = false
            topControlsView.isHidden = false
            self.navigationItem.setHidesBackButton(false, animated: true)
            updateRightBarButtonItem()
            readingSystemEngine.readerView.allowedGestureTypes = [.swipeNavigation,.panZoom]
        }
        view.layoutIfNeeded()
    }
}

extension ReaderEbookViewController:ContentMenuDelegate{
    func reload(tableView: UITableView) {
        tableView.reloadData()
    }
    
    func goingToBookMark(bookMark: Bookmark) {
        print(bookMark)
        
        let readerView = readingSystemEngine.readerView
        readerView.goTo(locator: SimpleLocatorData(sourceUrl: bookMark.urlPath ?? "", selectors: [bookMark.location ?? ""])){ data in
            switch data {
            case .success(_) :
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension ReaderEbookViewController:OnNavigationIntentEventListener{
    func onNavigationIntent(eventData: NavigationIntentEngineEventData) {
        eventData.relatedEvent?.target?.nodeData?.attributes.forEach{ attribute in
                    print(attribute.value)
                    if attribute.value == "noteref" || attribute.value.contains("#footnote")  {
                        readingSystemEngine.readerPublications.first!.getContentLocation(locator: eventData.locator).contentResolver.fetchTextContent{
                            result in
                            switch result{
                            case .success(let footnote):
                                print(footnote)
                            case.failure(let error):
                                print(error)
                            }
                        }
                        footnoteLocator = eventData.locator
                        footnoteIndexSpine = eventData.readerDocumentIndexInSpine ?? 0
                        let showPopupFootnote = FootnoteViewController(indexSpine: eventData.readerDocumentIndexInSpine ?? 0, locator: eventData.locator, urlFile: url)
                        floatingPanel.set(contentViewController: showPopupFootnote)
                        var panelLayput = IntrinsicPanelLayout()
                        
                        floatingPanel.layout = panelLayput
                        present(floatingPanel, animated: true)
                    } else if attribute.value.contains("#footnote") || attribute.value.contains("http://www.idpf.org/2007/ops") || attribute.value.contains("_idFootnoteLink _idGenColorInherit") {
                        readingSystemEngine.readerPublications.forEach{
                            publication in
                            publication.getContentLocation(locator: eventData.locator).contentResolver.fetchTextContentAfter(textLength:64){
                                result in
                                print(result)
                                switch result{
                                case .success(let footnote):
                                    print(footnote)
                                case.failure(let error):
                                    print(error)
                                }
                            }
                        }
                        print("success cant navigation")
                    } else {
                        readingSystemEngine.readerView.goTo(locator: eventData.locator){ result in
                            switch result{
                            case .success(_):
                                print("Success")
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
    }
}

extension ReaderEbookViewController:SearchDelegateController{
    func isEmpty(value: Bool) {
        if value {
            clearSearchButton.isHidden = true
        } else {
            clearSearchButton.isHidden = false
        }
    }
    
    func setSearch(query: ColibrioReader.ReaderDocumentSearchQuery, annotation: ColibrioReader.ReaderViewAnnotationLayer) {
        searchAgent = readingSystemEngine.readerDocumentSearch.createReaderViewSearchAgent(annotationLayer: annotation)
        searchAgent?.setSearchQuery(query: query)
    }
    
    func deleteAnnotationSearch(){
        do{
            try readingSystemEngine.readerView.annotationLayers?.forEach{ annotationLayer in
               try readingSystemEngine.readerView.destroyAnnotationLayer(annotationLayer)
            }
        } catch {
            
        }
    }
    
}

extension ReaderEbookViewController:ReaderPresenterOutput{
    func getRecord(response: RecordResponse) {
        BookManagerService().deleteAllAnalytic()
    }
    
    func getMessage(error: String) {
        let toast = Toast.default(image: UIImage(systemName: "xmark.circle.fill"), title:"Error Found", subtitle: error)
        toast.show(haptic: .error, after: 1)
    }
}

extension ReaderEbookViewController {
    func hideContentOnScreenCapture() {
        DispatchQueue.main.async { [self] in
            secureTextField.isSecureTextEntry = true
            
            colibrioView.addSubview(secureTextField)
            colibrioView.layer.superlayer?.addSublayer(secureTextField.layer)
            secureTextField.layer.sublayers?.first?.addSublayer(colibrioView.layer)
            
        }
    }
}
