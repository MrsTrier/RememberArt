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

var currentGame = Game(name: "", description: "", boardColor: .white, cardColor: .white, imagesForGame: [])

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

class DataSourse {
    
    let db = Firestore.firestore()
    var gamesList: [String] = []
    var gamesArray: [Game] = []

    func exessFullData() -> [Game] {
        var cardImage = Image(name: "", artist: "", description: "", url: nil, png: nil)

        
        db.collection("GameDataBase").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    for data in document.data() {
                        var gameJson: Dictionary<String, Any> = data.value as! Dictionary<String, Any>
                        currentGame.name = gameJson["gameName"] as! String
                        currentGame.boardColor = UIColor(hex: gameJson["boardColor"] as! String) ?? .white
                        currentGame.cardColor = UIColor(hex: gameJson["cardColor"] as! String) ?? .gray
                        currentGame.description = gameJson["description"] as! String
                        let images = gameJson["imagesForGame"] as! [Dictionary<String, Any>]
                        currentGame.imagesForGame = []
                        for image in images {
                            cardImage.artist = image["artist"] as! String
                            cardImage.name = image["imageName"] as! String
                            cardImage.description = image["description"] as! String
                            cardImage.url = URL(string: (image["url"] as! String))
                            currentGame.imagesForGame.append(cardImage)
                        }
                        self.gamesArray.append(currentGame)
                        currentGame.imagesForGame = []
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataReceived"), object: nil)
            }
        }
        return gamesArray
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
    
    func exessGameByName(gameName: String) -> Game {
        
        var cardImage = Image(name: "", artist: "", description: "", url: nil, png: nil)
        let array: [String] = ["Jackson Pollock", "Contemporary Art"]
        let gameId = String(array.firstIndex(of: gameName)! + 1)

        db.collection("GameDataBase").document(gameId).getDocument(completion: { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let gameJson: Dictionary<String, Any> = document!.data()![gameId] as! Dictionary<String, Any>
                    currentGame.name = gameJson["gameName"] as! String
                    currentGame.boardColor = UIColor(hex: gameJson["boardColor"] as! String) ?? .white
                    currentGame.cardColor = UIColor(hex: gameJson["cardColor"] as! String) ?? .gray
                    currentGame.description = gameJson["description"] as! String
                    let images = gameJson["imagesForGame"] as! [Dictionary<String, Any>]
                    currentGame.imagesForGame = []
                    for image in images {
                        cardImage.artist = image["artist"] as! String
                        cardImage.name = image["imageName"] as! String
                        cardImage.description = image["description"] as! String
                        cardImage.url = URL(string: (image["url"] as! String))
                        currentGame.imagesForGame.append(cardImage)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GameLoaded"), object: nil)
            }
        
        })
        return currentGame
    }

    
    var existingGames: [String] = ["Christmas", "Halloween", "Faces", "Animals"]
    
    var createdGames: [String] = []
    
    
    
//    var existingGamesData: [String : Game] = [
//        "Christmas":
//            Game(name: "Christmas",
//                 description: "",
//                 boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1),
//                 cardColor: #colorLiteral(red: 0.631328125, green: 0.1330817629, blue: 0.06264670187, alpha: 1),
//                 imagesForGame: [Image(name: "sky", artist:"dasha", description: "", url: nil, png: nil),
//                                 Image(name: "ira", artist:"dasha", description: "", url: nil, ),
//                                 Image(name: "ezha", artist:"dasha", description: "", url: nil),
//                                 Image(name: "photo", artist:"dasha", description: "", url: nil),
//                                 Image(name: "vorona", artist:"dasha", description: "", url: nil),
//                                 Image(name: "flower", artist:"dasha", description: "", url: nil),
//                                 Image(name: "winter", artist:"dasha", description: "", url: nil),
//                                 Image(name: "Iam", artist:"dasha", description: "", url: nil),
//                                 Image(name: "painting", artist:"dasha", description: "", url: nil),
//                                 Image(name: "pesa", artist:"dasha", description: "", url: nil)]
//        ),
//        "Halloween":
//            Game(name: "Halloween",
//                 description: "",
//                 boardColor: #colorLiteral(red: 1, green: 0.8556062016, blue: 0.5505848702, alpha: 1),
//                 cardColor: #colorLiteral(red: 0.7928710937, green: 0.373980853, blue: 0, alpha: 1),
//                 imagesForGame: [ Image(name: "sky", artist:"dasha", description: "", url: nil),
//                                  Image(name: "ira", artist:"dasha", description: "", url: nil),
//                                  Image(name: "ezha", artist:"dasha", description: "", url: nil),
//                                  Image(name: "photo", artist:"dasha", description: "", url: nil),
//                                  Image(name: "vorona", artist:"dasha", description: "", url: nil),
//                                  Image(name: "flower", artist:"dasha", description: "", url: nil),
//                                  Image(name: "winter", artist:"dasha", description: "", url: nil),
//                                  Image(name: "Iam", artist:"dasha", description: "", url: nil),
//                                  Image(name: "painting", artist:"dasha", description: "", url: nil),
//                                  Image(name: "pesa", artist:"dasha", description: "", url: nil)])
//    ]
}


extension DataSourse {
    
//    class func StringFromUIColor(color: UIColor) -> String {
//        let components = CGColor.components(color.cgColor)
//        return "[\(components[0]), \(components[1]), \(components[2]), \(components[3])]"
//    }
    
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
