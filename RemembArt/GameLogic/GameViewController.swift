//
//  GameViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController, PopUpViewProtocol {
    func shureTapped() {
        let  startvc =  self.navigationController?.viewControllers.filter({$0 is StartView}).first
        self.navigationController?.popToViewController(startvc!, animated: true)
    }
    

    func taskCreationDidCanceled() {
        
    }
    
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    var scoreLabel = UILabel()
    var gameCompleteLabel = UILabel()
//    var newGameButton = UIButton()

    var GameCardsStack = UIStackView()
    var GameCardsRowStacks = UIStackView()
    var cardButtons: [UIButton] = []
    
    var theme: Game! {
        didSet {
            implementTheme()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBarItems()

        UIApplication.shared.endIgnoringInteractionEvents()
        scoreLabel.frame = CGRect(x: (view.frame.width / 2 - 20), y: topDistance, width: 100, height: 30)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        newGameButton.frame = CGRect(x: (view.frame.width / 2 - 20), y: 100, width: 51, height: 30)
        var array: [UIStackView] = []
        GameCardsStack.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<5 {
            GameCardsRowStacks = CardsRow()
            array.append(GameCardsRowStacks)
        }
        GameCardsStack.axis = .vertical
        GameCardsStack.distribution = .fillEqually
        GameCardsStack.alignment = .fill
        GameCardsStack.spacing = 10.0
        
        GameCardsStack.addArrangedSubview(array[0])
        GameCardsStack.addArrangedSubview(array[1])
        GameCardsStack.addArrangedSubview(array[2])
        GameCardsStack.addArrangedSubview(array[3])
        GameCardsStack.addArrangedSubview(array[4])
        
        setupConstraints()
    }

    func setUpNavBarItems() {
        let titleView = theme.name
        navigationItem.title = titleView
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(_ :)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        
        let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "finish")!, andType: ["exit", "Do you realy want to exit the game?"])
        
        popUpView.frame = view.frame
        popUpView.delegate = self
        popUpView.makeVisible()
        
        view.addSubview(popUpView)
    }
    
    func CardsRow() -> UIStackView {
        let headerView = UIStackView()
        headerView.axis = .horizontal
        headerView.spacing = 10.0
        headerView.distribution = .fillEqually
        headerView.alignment = .fill
        
        let cardButton1 = UIButton()
        let cardButton = UIButton()
        let cardButton2 = UIButton()
        let cardButton3 = UIButton()
        
        cardButtons.append(cardButton)
        cardButtons.append(cardButton1)
        cardButtons.append(cardButton2)
        cardButtons.append(cardButton3)
        
        cardButton.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        cardButton1.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        cardButton2.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        cardButton3.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
        
        headerView.addArrangedSubview(cardButton1)
        headerView.addArrangedSubview(cardButton)
        headerView.addArrangedSubview(cardButton2)
        headerView.addArrangedSubview(cardButton3)

        return headerView
    }
    
    func setupConstraints() {
//        newGameButton.addTarget(self, action: #selector(touchNewGameButton(_:)), for: .touchUpInside)
        
        view.addSubview(gameCompleteLabel)
        view.addSubview(GameCardsStack)
        view.addSubview(scoreLabel)
        
        
        GameCardsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        GameCardsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        GameCardsStack.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor).isActive = true
        GameCardsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

    }
    
    private func implementTheme() {
        self.view.backgroundColor = theme.boardColor
        scoreLabel.textColor = theme.cardColor
        scoreLabel.text = ""
        gameCompleteLabel.textColor = theme.cardColor
        pickture = [:]
        unusedEmojis = theme.imagesForGame
        updateViewFromModel()

    }
    
    private lazy var game = Concentration(numberOfCards: cardButtons.count)
    
    @objc func touchCard(_ sender: UIButton)
    {
        if let index = cardButtons.firstIndex(of: sender) {
            let card = game.cards[index]
            if card.isFaceUp && !game.isGameComplete {
                let popUpView = PopUpView(frame: view.frame, andImage: sender.currentImage!, andType: ["default", "\((artWork(for: card)?.name)!)"])
                
                popUpView.frame = view.frame
                popUpView.delegate = self
                popUpView.makeVisible()
                
                view.addSubview(popUpView)
                
            } else {
                game.chooseCard(at: index)
                updateViewFromModel()
            }
        } else {
            print("This card is not part of the cards array")
        }
    }
    
    private func updateViewFromModel()
    {
        let scoreAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : theme.cardColor
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.score)", attributes: scoreAttributes)
        scoreLabel.attributedText = attributedString
        
        if game.isGameComplete {
            UIApplication.shared.beginIgnoringInteractionEvents()
            var popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "congratulation")!, andType: ["standart", "You finished the game with a score: \(game.score)"])
            popUpView.frame = view.frame
            popUpView.delegate = self
            popUpView.makeVisible()
            view.addSubview(popUpView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let  startvc =  self.navigationController?.viewControllers.filter({$0 is StartView}).first
                self.navigationController?.popToViewController(startvc!, animated: true)
            }
        } else {
            gameCompleteLabel.text = ""
            gameCompleteLabel.backgroundColor = .clear
            
        }
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                if game.isGameComplete {
                    break
                } else {
                    button.imageView?.contentMode = .scaleAspectFill
                    button.setImage(artWork(for: card)?.png, for: .normal)
                }
            } else if card.isMatched {
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
                button.setImage(nil, for: .normal)
            } else {
                button.setImage(nil, for: .normal)
                button.backgroundColor = theme.cardColor
                
            }
        }
    }
    
    //Code for selection of the emojis to appear on cards
    private var pickture = [Card: Image]()
    private var unusedEmojis: [Image] = []
    
    private func artWork(for card: Card) -> Image? {
        if pickture[card] == nil {
            let randomStringIndex = unusedEmojis.index(unusedEmojis.startIndex, offsetBy: unusedEmojis.count.arc4random)
//            pickture[card] = unusedEmojis.remove(at: randomStringIndex).png
            pickture[card] = unusedEmojis.remove(at: randomStringIndex)
        }
        return pickture[card]
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension UIImageView {
    func load(url: URL) -> UIImage? {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        return image
    }
}

