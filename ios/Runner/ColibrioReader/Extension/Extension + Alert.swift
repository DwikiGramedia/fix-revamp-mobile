//
//  Extension + Alert.swift
//  Runner
//
//  Created by Gramedia on 29/08/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    private var messageFont: [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: FontStyle.custom(14, weight: .regular).font,
                NSAttributedString.Key.foregroundColor: UIColor.init(named:"colorTextMessage")]
    }
    
    private var titleFont: [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: FontStyle.custom(16, weight: .bold).font,
                NSAttributedString.Key.foregroundColor: UIColor.init(named:"colorTextMessage")]
    }
    
    /**
     Shows an alert with given message
     - Parameter message: alert message
     */
    func showMessage(_ message: String) {
        // Create alert with ok button
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)

        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Shows an alert with given message
     - Parameter title: title message
     - Parameter message: alert message
     */
    func showMessage(_ title: String, _ message: String) {
        // Create alert with ok button
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)

        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Shows an alert with given message
     - Parameter title: title message
     - Parameter message: alert message
     - Callback action: Triggred action
     */
    func showMessage(_ title: String, _ message: String, callback: @escaping () -> Void) {
        // Create alert with ok button
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            callback()
        }
        alert.addAction(ok)
        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Shows an alert with given message
     - Parameter title: title message
     - Parameter message: alert message
     - Callback action: Triggred action
     */
    func showMessageWithOptionDialog(_ title: String, _ message: String, callback: @escaping () -> Void) {
        // Create alert with ok button
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: "Ya", style: .default) { (action) in
            callback()
        }
        alert.addAction(ok)
        
        let cancel = UIAlertAction(title: "Batal", style: .cancel)
        cancel.setValue(UIColor.cardinal, forKey: "titleTextColor")
        alert.addAction(cancel)
       
        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    func showMessageWithOptionDialog(_ title: String, _ message: String,
                                     _ yesButtonTitle: String = "Yes", _ noButtonTitle: String = "Cancel",
                                     callbackYes: @escaping () -> Void,
                                     callbackNo: @escaping () -> Void) {
        // Create alert with ok button
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")

        let ok = UIAlertAction(title: yesButtonTitle, style: .default) { (action) in
            callbackYes()
        }
        alert.addAction(ok)
        
        let cancelButton = UIAlertAction(title: noButtonTitle, style: .cancel) { (action) in
            callbackNo()
        }
        cancelButton.setValue(UIColor.cardinal, forKey: "titleTextColor")
        alert.addAction(cancelButton)
       
        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Logs given message
     */
    func log(_ message: String) {
        logToConsole(message)
    }
}

func logToConsole(_ message: String) {
    print(message)
}

