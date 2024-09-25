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
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
