//
//  DataBaseManager.swift
//  AppScanner
//
//  Created by Владимир Царь on 07.11.2025.
//

import Foundation
import CoreData

class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private init() { }
    
    var barCodes = [Barcode]()
    
    var qrCodes = [QrCode]()
    
    //MARK: Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ScanedModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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

extension DataBaseManager {
    //MARK: CRUD
    
    //Создаем bar-code в базе
    func createBarcode(name: String, ingredients: String, brand: String, nutriScore: String, id: String) {
        
        fetchBarCodes()
        
        if barCodes.contains(where: { $0.name == name }) {
            print("DUPLICATE: '\(name)' already exists")
            return
        }
        
        let _: Barcode = {
            $0.id = id
            $0.name = name
            $0.nutriScore = nutriScore
            $0.ingredients = ingredients
            $0.brand = brand
            $0.date = Date()
            return $0
        }(Barcode(context: persistentContainer.viewContext))
        
        saveContext()
        
    }
    
    //Получаем bar-code
    func fetchBarCodes() {
        let request = Barcode.fetchRequest()
        
        do {
            let barCodes = try persistentContainer.viewContext.fetch(request)
            self.barCodes = barCodes
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DataBaseManager {
    //MARK: CRUD
    
    //Создаем qr-code в базе
    func createQrCode(id: String) {
        
        fetchQrCodes()
        
        if barCodes.contains(where: { $0.id == id }) {
            print("DUPLICATE: '\(id)' already exists")
            return
        }
        
        let _: QrCode = {
            $0.id = id
            $0.date = Date()
            return $0
        }(QrCode(context: persistentContainer.viewContext))
        
        saveContext()
        
    }
    //Получаем qr-code
    func fetchQrCodes() {
        let request = QrCode.fetchRequest()
        
        do {
            let qrCodes = try persistentContainer.viewContext.fetch(request)
            self.qrCodes = qrCodes
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
