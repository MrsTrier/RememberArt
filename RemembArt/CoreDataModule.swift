//
//  CoreDataModule.swift
//  RemembArt
//
//  Created by Roman Cheremin on 02/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    /// Синглтон
    static let shared: CoreDataStack = {
        let shared = CoreDataStack()
        return shared
    }()
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GameModel")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer
    
    /// Загружаем имеющиеся данные из памяти
    ///
    /// - Returns: возвращаем массив с доступными играми
    func loadFromMemory() -> [AvailableGame] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AvailableGame")
        var games = [AvailableGame]()
        do {
            games = try managedContext.fetch(fetchRequest) as! [AvailableGame]
            return games
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func loadFromMemoryImages() -> [AvailableImage] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvailableImage")
        var images = [AvailableImage]()
        do {
            images = try managedContext.fetch(fetchRequest) as! [AvailableImage]
            return images
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    /// Очистка
    func clearData() {
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "AvailableGame")))
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "AvailableImage")))
    }
    
    /// Сохранение игр
    ///
    /// - Parameter gameList: массив доступных игр
    func save(_ gameList: [AvailableGame]) {
        clearData()
        persistentContainer.performBackgroundTask { (context) in
            for gameToSave in gameList {
                let game = AvailableGame(context: context)
                game.gameDescription = gameToSave.gameDescription
                game.gameName = gameToSave.gameName
                game.images = gameToSave.images
                try? context.save()
            }
        }
    }
    
    var data = DataSourse()
    var gameList: [String] = []
    var imagesForGame: [Image] = []
    var currentGames: [Game] = []

    
    /// Загрузка дефолтных значений из хранилища при первом запуске приложения
    func firstLaunchSettings() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "alreadyLaunched")
        if !launchedBefore {
            data.exessFullData()
            NotificationCenter.default.addObserver(self, selector: #selector(saveGames), name: NSNotification.Name(rawValue: "DataReceived"), object: nil)
        }
        //UserDefaults.standard.set(false, forKey: "launchedBefore") // для перезагрузки дефолтных значений
    }
    
    @objc func saveGames() {
        self.currentGames = data.returnAllGames()
        saveAllData()
//        NotificationCenter.default.addObserver(self, selector: #selector(saveGame), name: NSNotification.Name(rawValue: "ImagesSaved"), object: nil)
    }
    
    func saveAllData() {
        clearData()
        persistentContainer.performBackgroundTask { (context) in
            for game in self.currentGames {
                var arrayOfImages: [NSManagedObject] = []
                 let gameToSave = NSEntityDescription.insertNewObject(forEntityName: "AvailableGame", into: context)
                for image in game.imagesForGame {
                    var imageObj = NSEntityDescription.insertNewObject(forEntityName: "AvailableImage", into: context)
                    imageObj.setValue(image.name, forKey: "imageName")
                    imageObj.setValue(image.description, forKey: "imageDescription")
                    imageObj.setValue(image.artist, forKey: "artist")
                    imageObj.setValue(image.url, forKey: "url")
                    imageObj.setValue(gameToSave, forKey: "game")
                    arrayOfImages.append(imageObj)
                }
                gameToSave.setValue(game.name, forKey: "gameName")
                gameToSave.setValue(game.description, forKey: "gameDescription")
                gameToSave.setValue(NSSet.init(array: arrayOfImages), forKey: "images")

            }
            try? context.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ImagesSaved"), object: nil)
        }
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }

}
