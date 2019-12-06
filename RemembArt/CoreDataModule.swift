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
                game.imagesForGame = gameToSave.imagesForGame
                try? context.save()
            }
        }
    }
    
    var data = DataSourse()
    var gameList: [String] = []
    var imagesForGame: [Image] = []
    var currentGames: [Game] = []
//    var currentGame = Game(name: "", description: "", boardColor: .white, cardColor: .white, imagesForGame: [Image(name: "", artist: "", description: "", url: nil)])

    
    /// Загрузка дефолтных значений из хранилища при первом запуске приложения
    func firstLaunchSettings() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "alreadyLaunched")
        if !launchedBefore {
            data.exessFullData()
            NotificationCenter.default.addObserver(self, selector: #selector(saveGames), name: NSNotification.Name(rawValue: "DataReceived"), object: nil)
        }
        //UserDefaults.standard.set(false, forKey: "launchedBefore") // для перезагрузки дефолтных значений
    }
    
    @objc func safeData() {
        self.gameList = data.returnGamesList()
        for gameName in gameList {
            data.exessGameByName(gameName: gameName)
            NotificationCenter.default.addObserver(self, selector: #selector(saveGames), name: NSNotification.Name(rawValue: "GameLoaded"), object: nil)
        }
    }
    
    @objc func saveGames() {
        self.currentGames = data.returnAllGames()
        saveAllData()
        NotificationCenter.default.addObserver(self, selector: #selector(saveGame), name: NSNotification.Name(rawValue: "ImagesSaved"), object: nil)
    }
    
    func saveAllData() {
        clearData()
        persistentContainer.performBackgroundTask { (context) in
            for game in self.currentGames {
                for image in game.imagesForGame {
                    var imageObj = NSEntityDescription.insertNewObject(forEntityName: "AvailableImage", into: context)
                    imageObj.setValue(image.name, forKey: "imageName")
                    imageObj.setValue(image.description, forKey: "imageDescription")
                    imageObj.setValue(image.artist, forKey: "artist")
                    imageObj.setValue(image.url, forKey: "url")
                }
            }
            try? context.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ImagesSaved"), object: nil)
        }
    }
    
    @objc func saveGame() {
        persistentContainer.performBackgroundTask { (context) in
            for currentGame in self.currentGames {
                var arrayOfImages: [AvailableImage] = []
                var game = NSEntityDescription.insertNewObject(forEntityName: "AvailableGame", into: context)
                game.setValue(currentGame.name, forKey: "gameName")
                game.setValue(currentGame.description, forKey: "gameDescription")
                var images = self.loadFromMemoryImages()
                for imageFromDB in currentGame.imagesForGame {
                    for obj in images {
                        if obj.imageName == imageFromDB.name {
                            arrayOfImages.append(obj)
                            break
                        }
                    }
                }
                game.setValue(arrayOfImages, forKey: "imagesForGame")
            }
            try? context.save()
        }
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }

}
