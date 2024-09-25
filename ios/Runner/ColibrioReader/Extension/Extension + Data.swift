//
//  Extension + Data.swift
//  Runner
//
//  Created by Gramedia on 01/09/22.
//

import Foundation
import CryptoKit
import CommonCrypto

extension Data {
    public func sha256() -> String {
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            return NSData(bytes: hash, length: digestLength)
    }
    
    
    private  func hexStringFromData(input: NSData) -> String {
           var bytes = [UInt8](repeating: 0, count: input.length)
           input.getBytes(&bytes, length: input.length)
           
           var hexString = ""
           for byte in bytes {
               hexString += String(format:"%02x", UInt8(byte))
           }
           
           return hexString
       }
}

extension String {
    static var ZIP_SALT = "!@#$Gnjiolkuy44567890-yHUIkjhtrfgHY&0pl/09876`wdfBNJK"
    static var PDF_SALT = "pou56^YHNyfvbn@#$%^YJM./-[)12efvb%tgHJkL@#RghjI()P:?!][98yh"
    static var salt1 = "4d0470542b1e034b3386dd19236189ff"
    static var salt2 = "santiang"
    static var R1 = "~#%&"
    static var R2 = "*&#@!"
    static var R3 = "&%^)"

    func sha256() -> String{
            if let stringData = self.data(using: String.Encoding.utf8) {
                return stringData.sha256()
            }
            return ""
    }
}
