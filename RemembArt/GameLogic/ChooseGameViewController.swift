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
        if let theme = getThemeFromButton(sender) {
            let cvc = ConcentrationViewController()
            cvc.theme = theme
            navigationController?.pushViewController(cvc, animated: true)
        }
    }
    
    private func getThemeFromButton(_ sender: UIButton) -> Game? {
        //This is terrible behaviour. I'm identifying the theme to pick based off of the button's name, which makes the code very brittle. However, it will do for our purposes for the moment.
        let themeName = sender.currentTitle
        var theme: Game?
//        let dataSource = DataSourse()
//        dataSource.exessGameByName(gameName: "Jackson Pollock")
//        theme = dataSource.existingGamesData[themeName!]!
//        let group = DispatchGroup()
        var game: AvailableGame? = returnGameWithName(themeName!)
//        theme = returnGameWithName(themeName!)
        theme?.name = game!.gameName!
        theme?.description = game!.gameDescription!
        theme?.boardColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0)
        theme?.cardColor = .white
        for image in game!.imagesForGame! {
            var networkServece = NetworkService()
            var myUIImage = UIImage()
            networkServece.downloadImage(url: image.url!) { uiImage, error in
                DispatchQueue.main.async {
                    
                    guard let uiImage = uiImage else {
//                        alertMessage = "\(String(describing: error!.localizedDescription))"
                        return
                    }
                    myUIImage = uiImage
//                    self.imageModel.image = uiImage
//                    alertMessage = "Картинка скачана"
//                    self.output?.prepareAlert(with: alertMessage)
                }
            }
            
            var themeImage = Image(name: image.imageName!, artist: image.artist!, description: image.imageDescription!, url: image.url, png: myUIImage)
            theme!.imagesForGame.append(themeImage)
        }
//        theme = dataSource.exessGameByName(gameName: themeName!)
        return theme
    }
    
    func returnGameWithName(_ name: String) -> AvailableGame? {
        for game in games {
            if (game.gameName == name) {
                return game as AvailableGame?
            }
            return nil
        }
        return nil
    }
}

