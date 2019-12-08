//
//  GameViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, HolderViewDelegate {
    func animateLabel() {
        
    }
    
    var utils = Utilities()
    private var games = [AvailableGame]()
    private let stack = CoreDataStack.shared
    var gameData = Game(name: "", description: "", boardColor: .white, cardColor: .white, imagesForGame: [])


    var gameList: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white

    }

    var topDistance : CGFloat {
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        games = stack.loadFromMemory()
        
        let filter = filterStack(topDistance)
        var headerView = gameTypesStack(point: topDistance)
        view.addSubview(filter)
        view.addSubview(headerView)
//        data.exessGamesList()

    }
    
    var holderView = HolderView(frame: .zero)

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        addHolderView()
//
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        holderView.addOval()
        view.addSubview(holderView)
    }
    
    func filterStack(_ point: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: point, width: view.frame.width, height: 40))
        headerView.axis = .horizontal
        headerView.distribution = .fillEqually
        headerView.alignment = .fill
        headerView.spacing = 10.0
        
        var myGames = UIButton()
        myGames.backgroundColor = UIColor(red:0.95, green:0.85, blue:0.46, alpha:1.0)
        myGames.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
        myGames.setTitle("My Games", for: .normal)
        
        var allGames = UIButton()
        allGames.backgroundColor = UIColor(red:0.95, green:0.85, blue:0.46, alpha:1.0)
        allGames.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
        allGames.setTitle("All Games", for: .normal)
        
        myGames.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        allGames.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)

        headerView.addArrangedSubview(myGames)
        headerView.addArrangedSubview(allGames)

        return headerView
    }
    
    func gameTypesStack(point safeAreaPoint: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint + 50, width: view.frame.width, height: 300))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.alignment = .fill
        headerView.spacing = 10.0
        
        for game in games {
            let gameButton = UIButton()
            gameButton.backgroundColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0)
            gameButton.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
            gameButton.layer.cornerRadius = 30.0
            gameButton.setTitle(game.gameName, for: .normal)
            gameButton.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
            headerView.addArrangedSubview(gameButton)
        }
        return headerView
    }

    
    @objc func changeTheme(_ sender: UIButton) {
        let themeName = sender.currentTitle
        var game: AvailableGame = returnGameWithName(themeName!)!

        self.gameData = getThemeFromButton(game: game)!
        fillWithUIImages(game: game)
        NotificationCenter.default.addObserver(self, selector: #selector(loadGame), name: NSNotification.Name(rawValue: "ImagesLoaded"), object: nil)
    }
    
    @objc func loadGame() {
        let cvc = ConcentrationViewController()
        cvc.theme = gameData
        navigationController?.pushViewController(cvc, animated: true)
    }
    
    func fillWithUIImages(game: AvailableGame) {
        var myUIImages : [Image] = []
        for image in game.images! {
            var networkServece = NetworkService()            
            networkServece.downloadImage(url: (image as! AvailableImage).url!) { uiImage, error in
                
                DispatchQueue.main.async {
                    guard let uiImage = uiImage else {
                        return
                    }
                    var themeImage = Image(name: (image as! AvailableImage).imageName!, artist: (image as! AvailableImage).artist!, description: (image as! AvailableImage).imageDescription!, url: (image as! AvailableImage).url, png: uiImage)
                    myUIImages.append(themeImage)
                    if myUIImages.count >= 10 {
                        self.gameData.imagesForGame = myUIImages
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ImagesLoaded"), object: nil)
                    }
                }
            }
        }
    }
    
    func getThemeFromButton(game: AvailableGame) -> Game? {
    //This is terrible behaviour. I'm identifying the theme to pick based off of the button's name, which makes the code very brittle. However, it will do for our purposes for the moment.
    
        var theme = Game(name: game.gameName!, description: game.gameDescription!, boardColor: UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0), cardColor: .white, imagesForGame: [])
        return theme
    }
    
    func returnGameWithName(_ name: String) -> AvailableGame? {
        var neededGame: AvailableGame
        for game in games {
            if (game.gameName == name) {
                neededGame = game
                return neededGame
            }
        }
        return nil
    }
}

