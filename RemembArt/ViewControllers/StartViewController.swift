//
//  StartViewController.swift
//  RememberArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class StartView: UIViewController {
    
    
    var imageView = UIImageView()
    
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        imageView.frame = CGRect(x: 0, y: 150, width: screenWidth, height: screenWidth)
        imageView.image = UIImage(named: "circle")
        imageView.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0)
        let headerView = PlayOrCreateGame(point: topDistance)
        view.addSubview(imageView)

        view.addSubview(headerView)
    }
    
    func PlayOrCreateGame(point safeAreaPoint: CGFloat) -> UIStackView {
        
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint + 200, width: view.frame.width, height: 450))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.alignment = .fill
//                headerView.addBackground(color: UIColor(red:0.93, green:0.74, blue:0.42, alpha:1.0))
        
        let playButton = UIButton()
        playButton.backgroundColor = .clear
        playButton.setTitle("Play", for: .normal)
        playButton.sizeToFit()
        playButton.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 30)

        let createGameButton = UIButton()
        createGameButton.backgroundColor = .clear
        createGameButton.setTitle("Make a new game", for: .normal)
        createGameButton.sizeToFit()
        createGameButton.setTitleColor(.white, for: .normal)
        createGameButton.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 30)
        
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        createGameButton.addTarget(self, action: #selector(createGameTapped), for: .touchUpInside)
        
        headerView.spacing = 270.0
        headerView.addArrangedSubview(playButton)
        headerView.addArrangedSubview(createGameButton)
        
        return headerView
    }
    
    
    @objc func playTapped() {
        let cvc = ConcentrationThemeChooserViewController()
        navigationController?.pushViewController(cvc, animated: true)
    }

    @objc func createGameTapped() {
        let cvc = SignUpViewController()
        navigationController?.pushViewController(cvc, animated: true)

    }
}

