import UIKit
import Toast
import CoreData
import Flutter
import flutter_downloader
import ColibrioReader
import Zip
import CryptoSwift
import PDFKit
import FirebaseMessaging
import flutter_local_notifications
import Alamofire


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterResult: FlutterResult?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
        }
      
      let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
          //
      
      let tstChannel = FlutterMethodChannel(name: "com.apps-foundry.eperpuswl.id.eperpus/navToReader",
                                                binaryMessenger: flutterViewController.binaryMessenger)
      let eventChannel = FlutterEventChannel(name: "com.apps-foundry.eperpuswl.id.eperpus/download", binaryMessenger: flutterViewController.binaryMessenger)
      
        if let apiKey = Bundle.main.apiKey, let apiSecret = Bundle.main.apiSecret {
          try? ColibrioReaderFramework.shared.setLicenseOptions(licenseApiKey: apiKey, licenseApiSecret: apiSecret)
      }
      let navigationController = UINavigationController(rootViewController: flutterViewController)
      navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
      window?.makeKeyAndVisible()
      
      eventChannel.setStreamHandler(DownloadStreamHandler())
      
      tstChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "download"{
              
              guard let data = call.arguments else {
                  return
              }
              let myresult = data as? [String: Any]
              print(myresult!)
              guard let productId = myresult?["productId"] as? Int,let token = myresult?["token"] as? String,let brandId = myresult?["brandId"]as? Int,let editionCode = myresult?["editionCode"] as? String,let key = myresult?["key"] as? String,let fileType = myresult?["fileType"] as? String,let email = myresult?["email"] as? String, let userId = myresult?["user_id"] as? Int, let watermark = myresult?["watermark"] as? String, let clientId = myresult?["clientId"], let catalogId = myresult?["catalogId"], let borrowedId = myresult?["borrowedId"], let orgId = myresult?["organizationId"] else {
                  return
              }
              UserDefaults.standard.setValue(email, forKey: "email")
              UserDefaults.standard.setValue(userId, forKey: "user_id")
              UserDefaults.standard.setValue(token, forKey: "token")
              UserDefaults.standard.setValue(clientId, forKey: "clientId")
              UserDefaults.standard.setValue(catalogId, forKey: "catalogId")
              UserDefaults.standard.setValue(borrowedId, forKey: "borrowedId")
              UserDefaults.standard.setValue(orgId, forKey: "organizationId")
              
              let download = DownloadManager()
              let book = Book(context: CoreDataBrain().context)
              
              DispatchQueue.main.async {
                  
                  download.download(id: productId, token: token){ callback in
                      switch callback {
                      case .success(let url):
                          print(url.absoluteString)
                          
                          book.filePathZip = url.absoluteString
                          book.productId = Int32(productId)
                          book.key = key
                          book.fileType = fileType
                          book.brandId = Int32(brandId)
                          book.editionCode = editionCode
                          book.watermark = watermark
                          do{
                              try  self.persistentContainer.viewContext.save()
                              result(Int(download.progress ?? 0.0) * 100)
                          }catch let err {
                              print(err)
                          }
                      case .failure(let failure):
                          print(failure.errorDescription)
                      }
                  }
              }
          } else if call.method == "cancelEvent" {
              
          } else if call.method == "delete"{
              guard let data = call.arguments else {
                  return
              }
              let myresult = data as? [String: Any]
              let productId = myresult?["productId"] as? Int
             
              guard let book = fetchBook(productId: "\(productId ?? 0)") else{
                  return
              }
              do{
                  let urlFile = URL(string: book.filePathZip!)!.deletingPathExtension().deletingLastPathComponent()
                  print(urlFile)
                  try FileManager.default.removeItem(at: urlFile)
                 CoreDataBrain().context.delete(book)
                  try CoreDataBrain().context.save()
                  
              }catch let err {
                  print(err)
              }
          } else if call.method == "totalAnalytic" {
              var readerWorker = ReaderWorker()
              var valueAnalytic = readerWorker.valuePages() ?? []
              result(valueAnalytic.count)
          } else if call.method == "syncReader" {
              var readerWorker = ReaderWorker()
              var valueAnalytic = readerWorker.valuePages() ?? []
              readerWorker.recordEpp(body: RecordParameterEpp(pageviews: valueAnalytic)){ (result) in
                  switch result {
                  case .success(let success):
                      if success.user_message == nil {
                          BookManagerService().deleteAllAnalytic()
                          let toast = Toast.default(image: UIImage(systemName: "checkmark.shield.fill"), title:"Success Send", subtitle: "Analytics data have sent")
                          toast.show(haptic: .error, after: 1)
                      } else {
                          let toast = Toast.default(image: UIImage(systemName: "xmark.circle.fill"), title:"Error Found", subtitle: success.user_message ?? "User Error")
                          toast.show(haptic: .error, after: 1)
                      }
                  case .failure(_):
                      let toast = Toast.default(image: UIImage(systemName: "xmark.circle.fill"), title:"Error Found", subtitle: "Connection Error")
                      toast.show(haptic: .error, after: 1)
                  }
              }
          }
          else if call.method == "epub"{
            
              guard let data = call.arguments else {
                  return
              }
              let myresult = data as? [String: Any]
              
              let productId = myresult?["productId"] as? Int
              guard let book = fetchBook(productId: "\(productId ?? 0)") else{
                  return
              }
              if NetworkMonitorObserver.isConnected == false {
                  let toast = Toast.default(image: UIImage(systemName: "xmark.circle.fill"), title:"Offline Mode", subtitle: "Reading season send when Online mode")
                  toast.show(haptic: .error, after: 1)
              }
              
              if  book.filePathBook != nil {
                  let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
                  print(urlFile.count)
                  let temprorary = FileManager.default.temporaryDirectory
                  let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
                  navigationReader(navigation: navigationController, url: filePath, book: book)
              }
          } else if call.method == "pdf" {
              guard let data = call.arguments else {
                  return
              }
              let myresult = data as? [String: Any]
              let productId = myresult?["productId"] as? Int
              let item_type = myresult?["itemType"] as? String
              
              guard let book = fetchBook(productId: "\(productId ?? 0)") else{
                  return
              }
              
              if NetworkMonitorObserver.isConnected == false {
                  let toast = Toast.default(image: UIImage(systemName: "xmark.circle.fill"), title:"Offline Mode", subtitle: "Reading season send when Online mode")
                  toast.show(haptic: .error, after: 1)
              }
              if book.filePathBook != nil {
                  let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
                  print(urlFile)
                  let temprorary = FileManager.default.temporaryDirectory
                  let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
                
                      navigationReader(navigation: navigationController, url: filePath, book: book)
                  
                 
              }
          } else {
              
          }
      })
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
    }
    
    override func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eperpus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

func fetchBook(productId:String)->Book?{
    let request:NSFetchRequest<Book> = Book.fetchRequest()
    request.predicate = NSPredicate(format: "productId == %@", productId)
    do{
        let dataArray = try CoreDataBrain().context.fetch(request)
        if dataArray.isEmpty {
            return nil
        } else {
            return dataArray.last
        }
    }catch let error {
        print(error)
        return nil
    }
}

func unzipFile(urlFromPath:URL,password:String,id:Int) -> URL? {
    do{
        
        let destination = urlFromPath.deletingPathExtension().deletingLastPathComponent()
            try Zip.unzipFile(urlFromPath, destination: destination, overwrite: true, password: password)
            return destination
           
    }catch let error {
        print(String(describing: error))
        return nil
    }
}

func unzipFileforEpub(urlFromPath:URL,password:String,id:Int) -> URL? {
    do{
        
            let destination = FileManager.default.temporaryDirectory.appendingPathComponent("\(id)")
            try Zip.unzipFile(urlFromPath, destination: destination, overwrite: true, password: password)
            return destination
           
    }catch let error {
        print(String(describing: error))
        return nil
    }
}

private func navigationReader(navigation:UINavigationController,url:URL,book:Book){
    if book.fileType == "pdf"{
        navigation.isNavigationBarHidden = false
        navigation.pushViewController(ReaderEbookViewController(url: url, book: book), animated: true)
    } else {
        navigation.pushViewController(ReaderEbookViewController(url: url, book: book), animated: true)
        navigation.isNavigationBarHidden = false
    }
    
}
private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}

func installingPDF(url:URL,moc:NSManagedObjectContext,book:Book,id:Int,brandId:Int,key:String,editionCode:String,fileType:String){
    
        do{
            let password = "\(id)\(String.R1)\(String.ZIP_SALT)\(String.R2)\(brandId )\(String.R3)\(key)"
            print(password)
        //    let password2 = "\(detailResponse?.id ?? "")\(String.R1)\(String.ZIP_SALT)\(String.R2)\(detailResponse?.brandID ?? 48684)\(String.R3)\(metaKey?.data?.key ?? "")"
 
            let createPasswordPdf = "\(id)\(String.R1)\(String.PDF_SALT)\(String.R2)\(brandId)\(String.R3)\(key)".sha256()
            print(createPasswordPdf)
            let pathBook:URL? = unzipFile( urlFromPath: url, password: password.sha256(), id: id)
            print(pathBook)
            let pdfBook: URL? = pathBook?.appendingPathComponent("magazine.pdf")
            print(pdfBook)
//            let pdfData = try Data(contentsOf: pdfBook!)
//            print(pdfData)
//            let cgPdf = try removePassword(data: pdfData, existingPDFPassword: createPasswordPdf)
//            try cgPdf?.write(to: pdfBook!)
            print(FileManager.default.fileExists(atPath: pdfBook?.path ?? ""))
            
            book.productId  = Int32(id)
            book.filePathBook = pdfBook?.absoluteString
            book.key = createPasswordPdf
            try CoreDataBrain().context.save()
            
        } catch let error {
            print(error)
            
            
        }
}
func installingEpub(url:URL,moc:NSManagedObjectContext,book:Book,id:Int,brandId:Int,key:String,editionCode:String,fileType:String){
    
        do{
            
            let password = "\(id)\(String.R1)\(String.ZIP_SALT)\(String.R2)\(brandId )\(String.R3)\(key)"
        //    let password2 = "\(detailResponse?.id ?? "")\(String.R1)\(String.ZIP_SALT)\(String.R2)\(detailResponse?.brandID ?? 48684)\(String.R3)\(metaKey?.data?.key ?? "")"
            
            let createPasswordPdf = "\(id)\(String.R1)\(String.PDF_SALT)\(String.R2)\(brandId)\(String.R3)\(key)".sha256()
            let pathBook:URL? = unzipFileforEpub( urlFromPath: url, password: password.sha256(), id: id)
            
            let epubBook: URL? = pathBook?.appendingPathComponent("magazine.epub")
            
            
            let epubZip = (epubBook?.deletingPathExtension().appendingPathExtension("zip"))!
            print(FileManager.default.fileExists(atPath: epubZip.path))
            if FileManager.default.fileExists(atPath: epubZip.path){
                try FileManager.default.removeItem(at: epubZip)
            }
            try FileManager.default.moveItem(at: epubBook!, to: epubZip)
            let url = unzipEpub(from: epubZip, id: id)
            
            let contents:[URL] = try FileManager.default.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil)
            
            let keyEpub = createKeyContainerXML(product_id: "\(id)", editionCode: editionCode)
            print(keyEpub)
            print(contents)
            decryptEpubStep(urls: contents, epubKey: keyEpub)
            
            let urlnewContent = try Zip.quickZipFiles(contents, fileName: "unlockmagazine")
            let fileTemporary = FileManager.default.temporaryDirectory.appendingPathComponent("\(id)").appendingPathComponent("unlock.epub")
            if FileManager.default.fileExists(atPath: fileTemporary.path){
                try FileManager.default.removeItem(at: fileTemporary)
            }
            try FileManager.default.moveItem(at: urlnewContent, to: fileTemporary)
            print(fileTemporary)
            book.productId = Int32(id)
            book.filePathBook = fileTemporary.absoluteString
            try CoreDataBrain().context.save()
            
        } catch let error {
            print(error)
        }
}
private func decryptEpubStep(urls:[URL],epubKey:String){
    do {
        for i in urls {
            if i.absoluteString.contains(".xhtml") || i.absoluteString.contains(".xml") || i.absoluteString.contains(".html"){
                print("Content \(i)")
                let a = formattedContentString(url: i, metaEpubFileKey: epubKey)
                print(a)
                
            }
             else {
                 if let dataContents = try? FileManager.default.contentsOfDirectory(at: i, includingPropertiesForKeys: nil) {
                     decryptEpubStep(urls: dataContents, epubKey: epubKey)
                 } else {
                     continue
                 }
            }
        }
    }catch {
        print(error)
    }
}

func formattedContentString(url:URL,metaEpubFileKey: String)-> String?{
    do{
        let convertData:Data = try Data(contentsOf: url)
        let ivData = Data(hex: "00000000000000000000000000000000").bytes
        //var epubKey = Data(bytes: metaEpubFileKey.bytes, count: 16)
//            var cryptorData = try AES(key: metaEpubFileKey, iv: "0000000000000000",padding: .pkcs5)
        let cryptor = try AES(key: Data(hex:metaEpubFileKey).bytes, blockMode: CBC(iv: ivData),padding: .pkcs7)
        let decryptBytes = try cryptor.decrypt(convertData.bytes)
        print(decryptBytes.toBase64())
        let stringData = Data(decryptBytes)
        print(stringData)
        try stringData.write(to: url)
        let stringValue = String(data: stringData, encoding: .utf8)
        print(stringValue ?? "")
        _ = Data(decryptBytes)
        return stringValue
    }catch let error{
        debugPrint(error)
        return nil
    }
}

func createKeyContainerXML(product_id:String,editionCode:String)-> String{
    var key = "\(product_id)\(String.salt1)\(editionCode)\(String.salt2)".sha256()
    print(key)
    var index = 1
    let n = ((Int(product_id) ?? 0) % 100) + 3
    print(n)
    print(key)
    while index < n {
        key = "\(key)\(String.salt1)".sha256()
        print(key)
        index += 1
    }
    let keyCharacters = Array(key)
    var indexData = 0
    var stringKey = ""
    while indexData < 32 {
        stringKey.append(String(keyCharacters[indexData]))
        indexData += 1
    }
    debugPrint("Key hashe  " + stringKey)
    return stringKey
}

func unzipEpub(from:URL,id:Int)->URL?{
    do{
        print(from)
        let destination = FileManager.default.temporaryDirectory.appendingPathComponent("\(id)").appendingPathComponent("epub")
        print(destination)
        try Zip.unzipFile(from, destination: destination, overwrite: true, password: "")
        return destination
    } catch let e {
        print(e)
        return nil
    }
}

func unlock(data: Data, password: String) -> CGPDFDocument? {
    if let pdf = CGPDFDocument(CGDataProvider(data: data as CFData)!) {
        guard pdf.isEncrypted == true else { return pdf }
        guard pdf.unlockWithPassword("") == false else { return pdf }
        if let cPasswordString = password.cString(using: String.Encoding.utf8) {
            if pdf.unlockWithPassword(cPasswordString) {
                return pdf
            }
        }
    }
    return nil
}

func removePassword(data: Data, existingPDFPassword: String) throws -> Data? {
    if let pdf = unlock(data: data, password: existingPDFPassword) {
        let data = NSMutableData()
        autoreleasepool {
            let pageCount = pdf.numberOfPages
            UIGraphicsBeginPDFContextToData(data, .zero, nil)
            for index in 1...pageCount {
                let page = pdf.page(at: index)
                let pageRect = page?.getBoxRect(CGPDFBox.mediaBox)
                UIGraphicsBeginPDFPageWithInfo(pageRect!, nil)
                let ctx = UIGraphicsGetCurrentContext()
                    ctx?.interpolationQuality = .high
// Draw existing page
                    ctx!.saveGState()
                    ctx!.scaleBy(x: 1, y: -1)
                    ctx!.translateBy(x: 0, y: -(pageRect?.size.height)!)
                    ctx!.drawPDFPage(page!)
                    ctx!.restoreGState()
                }
            UIGraphicsEndPDFContext()
            }
        return data as Data
        }
    return nil
    }


class DownloadStreamHandler:NSObject,FlutterStreamHandler{
    private var eventSink: FlutterEventSink?
    private var timer:Timer?
    var download:DownloadRequest?
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        download?.cancel()
        self.eventSink = nil
        return nil
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        
        let book = Book(context: CoreDataBrain().context)
        guard let eventSink = eventSink else { fatalError() }
            guard let data = arguments else {
                fatalError()
            }
            let myresult = data as? [String: Any]
            print(myresult!)
            guard let productId = myresult?["productId"] as? Int,let token = myresult?["token"] as? String,let brandId = myresult?["brandId"]as? Int,let editionCode = myresult?["editionCode"] as? String,let key = myresult?["key"] as? String,let fileType = myresult?["fileType"] as? String,let email = myresult?["email"] as? String, let userId = myresult?["user_id"] as? Int, let watermark = myresult?["watermark"] as? String, let clientId = myresult?["clientId"], let catalogId = myresult?["catalogId"], let borrowedId = myresult?["borrowedId"], let orgId = myresult?["organizationId"] else {
                fatalError()
            }
        
            UserDefaults.standard.setValue(brandId, forKey:"brandIdBook")
            UserDefaults.standard.setValue(productId, forKey:"productId")
            UserDefaults.standard.setValue(key, forKey:"keyBook")
            UserDefaults.standard.setValue(watermark, forKey:"watermarkBook")
            UserDefaults.standard.setValue(editionCode, forKey:"editionCodeBook")
            UserDefaults.standard.setValue(fileType, forKey:"fileType")
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.setValue(userId, forKey: "user_id")
            UserDefaults.standard.setValue(token, forKey: "token")
            UserDefaults.standard.setValue(clientId, forKey: "clientId")
            UserDefaults.standard.setValue(catalogId, forKey: "catalogId")
            UserDefaults.standard.setValue(borrowedId, forKey: "borrowedId")
            UserDefaults.standard.setValue(orgId, forKey: "organizationId")
           
        let progressQueue = DispatchQueue(label:"com.alamofire.progressQueue",qos:.utility)
        let fileTemporary = FileManager.default.temporaryDirectory.appendingPathComponent("\(productId)").appendingPathComponent("\(productId).zip")

        let destination: DownloadRequest.Destination = {_,_ in
            return (fileTemporary,[.removePreviousFile, .createIntermediateDirectories])
        }
        let header = HTTPHeaders(["Authorization":"\(token)"])
         download = AF.download("https://scoopadm.apps-foundry.com/scoopcor/api/v1/items/\(productId)/download",headers: header, to: destination).downloadProgress(queue: progressQueue,closure: {progress in
             
                 events(progress.fractionCompleted)
             
        }).responseURL{ response in
            switch response.result {
            case .success(let url):
                print(url.absoluteString)
                
                book.filePathZip = url.absoluteString
                book.productId = Int32(productId)
                book.key = key
                book.fileType = fileType
                book.brandId = Int32(brandId)
                book.editionCode = editionCode
                book.watermark = watermark
                do{
                    try  CoreDataBrain().saveData()
                    installing(fileType: fileType, productId: productId)
                    events(1.0)
                    events(FlutterEndOfEventStream)
                }catch let err {
                    print(err)
                }
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
            
        
        
        return nil
    }
}

func installing(fileType:String,productId:Int){
    guard let book = fetchBook(productId: "\(productId ?? 0)") else{
        return
    }
  
    if fileType == "epub"{
        
        
        if  book.filePathBook != nil {
            let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
            print(urlFile.count)
            let temprorary = FileManager.default.temporaryDirectory
            let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
            
        } else {
            
            installingEpub(url:  URL(string: book.filePathZip ?? "")!, moc: CoreDataBrain().context, book: book, id: productId ?? 0, brandId: Int(book.brandId ), key: book.key ?? "", editionCode: book.editionCode ?? "", fileType: book.fileType ?? "")
            let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
            print(urlFile.count)
            let temprorary = FileManager.default.temporaryDirectory
            let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
            
        }
    } else {
        if book.filePathBook != nil {
            let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
            print(urlFile)
            let temprorary = FileManager.default.temporaryDirectory
            let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
            
            
        } else {
            installingPDF(url: URL(string: book.filePathZip ?? "")!, moc: CoreDataBrain().context, book: book, id: productId ?? 0, brandId: Int(book.brandId ), key: book.key ?? "", editionCode: book.editionCode ?? "", fileType: book.fileType ?? "")
            let urlFile = book.filePathBook?.components(separatedBy: "/") ?? []
            print(urlFile)
            let temprorary = FileManager.default.temporaryDirectory
            let filePath = temprorary.appendingPathComponent("\(urlFile[urlFile.count - 2])").appendingPathComponent("\(urlFile[urlFile.count - 1])")
            
        }
    }
}

