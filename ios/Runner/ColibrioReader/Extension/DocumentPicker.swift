//
//  DocumentPicker.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers // For iOS 14+

/**
 Responsible for presenting a document picker and invoking a callback with the result url
 */
final class DocumentPicker: NSObject, UIDocumentPickerDelegate {

    private var onDocumentPicked: ((URL) -> Void)?

    /**
     Presents a system document picker for selecting a epub or pdf file
     - Parameters:
       - presenterVc: The presenter view controller
       - onDocumentPicked: Called when a file is picked
     */
    func presentDocumentPicker(presenterVc: UIViewController, onDocumentPicked: @escaping (URL) -> Void) {
        self.onDocumentPicked = onDocumentPicked

        if #available(iOS 14.0, *) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.epub, UTType.pdf], asCopy: false)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet

            presenterVc.present(documentPicker, animated: true, completion: nil)
        } else {
            let types: [String] = [kUTTypePDF as String, kUTTypeElectronicPublication as String, "org.idpf.epub-container"]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            presenterVc.present(documentPicker, animated: true, completion: nil)
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }

        onDocumentPicked?(url)
    }
}


