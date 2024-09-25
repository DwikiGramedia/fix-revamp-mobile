//
//  CoredataBrain.swift
//  Runner
//
//  Created by Gramedia on 19/12/22.
//

import UIKit
import CoreData

class CoreDataBrain {
    /// Core Data context from UIApplication
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    /**
     This method use for saving data to Core Data
    */
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
}
