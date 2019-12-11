//
//  FromFirestoreToCD.swift
//  RemembArt
//
//  Created by Roman Cheremin on 11/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

//import UIKit
//import Firebase
//import CoreData
//
//
//class FromFirestoreToCD {
//    
//    static let shared: FromFirestoreToCD = {
//        let shared = FromFirestoreToCD()
//        return shared
//    }()
//    
//    private init() {
//        persistentContainer = NSPersistentContainer(name: "GameModel")
//        persistentContainer.loadPersistentStores { storeDescription, error in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//        }
//    }
//    
//    var persistentContainer: NSPersistentContainer
//    let db = Firestore.firestore()
//    
//    func loadFromMemory() -> [AvailableGame] {
//        let managedContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AvailableGame")
//        var games = [AvailableGame]()
//        do {
//            games = try managedContext.fetch(fetchRequest) as! [AvailableGame]
//            return games
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            return []
//        }
//    }
//
//    func loadFromMemoryImages() -> [AvailableImage] {
//        let managedContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvailableImage")
//        var images = [AvailableImage]()
//        do {
//            images = try managedContext.fetch(fetchRequest) as! [AvailableImage]
//            return images
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            return []
//        }
//    }
//
//    
//    func firstLaunchSettings() {
//        let launchedBefore = UserDefaults.standard.bool(forKey: "alreadyLaunched")
//        if !launchedBefore {
//            allDataFromFirestoreToCD()
////            NotificationCenter.default.addObserver(self, selector: #selector(saveGames), name: NSNotification.Name(rawValue: "allDataFromFirestoreReceived"), object: nil)
//        }
//        //UserDefaults.standard.set(false, forKey: "launchedBefore") // для перезагрузки дефолтных значений
//    }
//    
//    
//    
//    
//    func clearData() {
//        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "AvailableGame")))
//        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "AvailableImage")))
//    }
//    
//    func allDataFromFirestoreToCD() {
//        persistentContainer.performBackgroundTask { (context) in
//            self.db.collection("GameDataBase").getDocuments { (snapshot, error) in
//                if error == nil && snapshot != nil {
//                    for document in snapshot!.documents {
//                        for data in document.data() {
//                            var gameJson: Dictionary<String, Any> = data.value as! Dictionary<String, Any>
//                            let images = gameJson["imagesForGame"] as! [Dictionary<String, Any>]
//                            var arrayOfImages: [NSManagedObject] = []
//                            let gameToSave = NSEntityDescription.insertNewObject(forEntityName: "AvailableGame", into: context)
//                            for image in images {
//                                let imageObj = NSEntityDescription.insertNewObject(forEntityName: "AvailableImage", into: context)
//                                imageObj.setValue(image["imageName"] as! String, forKey: "imageName")
//                                imageObj.setValue(image["description"] as! String, forKey: "imageDescription")
//                                imageObj.setValue(image["artist"] as! String, forKey: "artist")
//                                imageObj.setValue(URL(string: (image["url"] as! String)), forKey: "url")
//                                imageObj.setValue(gameToSave, forKey: "game")
//                                arrayOfImages.append(imageObj)
//                            }
//                            gameToSave.setValue(gameJson["gameName"] as! String, forKey: "gameName")
//                            gameToSave.setValue(gameJson["description"] as! String, forKey: "gameDescription")
//                            gameToSave.setValue(NSSet.init(array: arrayOfImages), forKey: "images")
//                        }
//                    }
//                }
//            }
//            try? context.save()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "allDataFromFirestoreReceived"), object: nil)
//        }
//        UserDefaults.standard.set(true, forKey: "launchedBefore")
//    }
//}
