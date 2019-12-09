//
//  SignUpViewController.swift
//  RememberArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let buttonsStack = ButtonsStack()
        view.addSubview(buttonsStack)
        // Do any additional setup after loading the view.
    }
    
    
    func ButtonsStack() -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: topDistance, width: view.frame.width, height: 300))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.alignment = .center
        
        let logInBotton = UIButton()
        logInBotton.setTitleColor(.blue, for: .normal)
        logInBotton.setTitle("Log in", for: .normal)
        
        let signUpButton = UIButton()
        signUpButton.setTitleColor(.blue, for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
        logInBotton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        headerView.addArrangedSubview(logInBotton)
        headerView.addArrangedSubview(signUpButton)
        
        return headerView
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let cvc = AuthoriseUserViewController(sender.currentTitle)
        navigationController?.pushViewController(cvc, animated: true)
    }

}


extension SignUpViewController {
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
}
