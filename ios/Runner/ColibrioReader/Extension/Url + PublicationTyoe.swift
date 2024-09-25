//
//  Url + PublicationTyoe.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//
import Foundation
import ColibrioReader

extension URL {
    /**
     Gets publication type based on URL path extension
     - Returns: epub, pdf, or nil in case type is not supported
     */
    func getPublicationType() -> PublicationType? {
        if (pathExtension.caseInsensitiveCompare("epub") == .orderedSame) {
            return .epub
        } else if (pathExtension.caseInsensitiveCompare("pdf") == .orderedSame) {
            return .pdf
        } else {
            return nil
        }
    }
}
