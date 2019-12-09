//
//  GameTheme.swift
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit
import Firebase

struct Image {
    var name: String
    var artist: String
    var description: String
    var url: URL?
    var png: UIImage?
}

struct Artist {
    var name: String
    var works: [Image]
}

struct Game {
    /// The name of the theme (i.e. to show it on screen or something)
    var name: String
    
    var description: String
    /// The color of the board
    var boardColor: UIColor
    
    /// The color of the card's back
    var cardColor: UIColor
    
    /// Array of available images fot the theme
    var imagesForGame: [Image]
}

class DataSource: NSObject {
    
    var currentGame = Game(name: "", description: "", boardColor: .white, cardColor: .white, imagesForGame: [])
    var currentArtist = Artist(name: "", works: [])
    
    var pickerData = [""]
    
    var arrayOfImg: Array<String> = ["sky", "ira", "ezha", "photo", "vorona", "flower","winter","Iam", "painting", "pesa"]
    
    let db = Firestore.firestore()
    var gamesList: [String] = []
    var gamesArray: [Game] = []
    var artistsArray: [Artist] = []

    func exessFullGameData() {
        var cardImage = Image(name: "", artist: "", description: "", url: nil, png: nil)
        
        db.collection("GameDataBase").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    for data in document.data() {
                        var gameJson: Dictionary<String, Any> = data.value as! Dictionary<String, Any>
                        self.currentGame.name = gameJson["gameName"] as! String
                        self.currentGame.boardColor = UIColor(hex: gameJson["boardColor"] as! String) ?? .white
                        self.currentGame.cardColor = UIColor(hex: gameJson["cardColor"] as! String) ?? .gray
                        self.currentGame.description = gameJson["description"] as! String
                        let images = gameJson["imagesForGame"] as! [Dictionary<String, Any>]
                        self.currentGame.imagesForGame = []
                        for image in images {
                            cardImage.url = URL(string: (image["url"] as! String))
                            cardImage.artist = image["artist"] as! String
                            cardImage.name = image["imageName"] as! String
                            cardImage.description = image["description"] as! String
                            self.currentGame.imagesForGame.append(cardImage)
                        }
                    }
                    self.gamesArray.append(self.currentGame)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataReceived"), object: nil)
            }
        }
    }
    
    func exessFullImageData() {
        var cardImage = Image(name: "", artist: "", description: "", url: nil, png: nil)
        
        db.collection("ImageStorage").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    for artistData in document.data() {
                        var artistJson: Dictionary<String, Any> = artistData.value as! Dictionary<String, Any>
                        self.currentArtist.name = artistJson["artistName"] as! String
                        let works = artistJson["works"] as! [Dictionary<String, Any>]
                        self.currentArtist.works = []
                        for picture in works {
                            cardImage.url = URL(string: (picture["url"] as! String))
                            cardImage.artist = self.currentArtist.name
                            cardImage.name = picture["imageName"] as! String
                            cardImage.description = picture["imageDescription"] as! String
                            self.currentArtist.works.append(cardImage)
                        }
                    }
                    self.artistsArray.append(self.currentArtist)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ImageDataReceived"), object: nil)
            }
        }
    }
    
    func exessGamesList() -> [String] {
        
        db.collection("GameDataBase").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                var i = 0
                for document in snapshot!.documents {
                    var names = ["1", "2"]
                    var json: Dictionary<String, Any> = document.data()[names[i]] as! Dictionary<String, Any>
                    self.gamesList.append(json["gameName"] as! String)
                    i = i + 1
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DocumentReceived"), object: nil)
            }
        }
        return gamesList
    }
    
    
    func returnGamesList() -> [String] {
        return gamesList
    }
    
    func returnGame() -> Game {
        return currentGame
    }
    
    func returnAllGames() -> [Game] {
        return gamesArray
    }

    func returnImageData() -> [Artist] {
        return artistsArray
    }
    
    var createdGames: [String] = []
    
}


extension DataSource {
    
    func UIColorFromString(string: String) -> UIColor {
        let componentsString = string.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                       green: CGFloat((components[1] as NSString).floatValue),
                       blue: CGFloat((components[2] as NSString).floatValue),
                       alpha: CGFloat((components[3] as NSString).floatValue))
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
}


extension DataSource: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
}
