//
//  ViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
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
        let headerView = GameTypesStack(point: topDistance)
        view.addSubview(headerView)
    }
    
    func GameTypesStack(point safeAreaPoint: CGFloat) -> UIStackView {
        
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint, width: view.frame.width, height: 300))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.alignment = .center
        //        headerView.addBackground(color: UIColor(red:0.93, green:0.74, blue:0.42, alpha:1.0))
        
        let halloweenButton = UIButton()
        halloweenButton.tintColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        halloweenButton.setTitle("Halloween", for: .normal)
        
        let sportsButton = UIButton()
        sportsButton.tintColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        sportsButton.setTitle("Christmas", for: .normal)
        
        
        let religionButton = UIButton()
        religionButton.tintColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        religionButton.setTitle("Animals", for: .normal)
        
        let japanButton = UIButton()
        japanButton.tintColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        japanButton.setTitle("Faces", for: .normal)
        
        halloweenButton.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        japanButton.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        religionButton.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        sportsButton.addTarget(self, action: #selector(changeTheme(_:)), for: .touchUpInside)
        
        headerView.addArrangedSubview(halloweenButton)
        headerView.addArrangedSubview(sportsButton)
        headerView.addArrangedSubview(religionButton)
        headerView.addArrangedSubview(japanButton)
        
        return headerView
    }
    
    
    @objc func changeTheme(_ sender: UIButton) {
        if let theme = getThemeFromButton(sender) {
            let cvc = ConcentrationViewController()
            cvc.theme = theme
            //            if let cvc = splitViewDetailConcentrationViewController {
            //                cvc.theme = theme
            //            } else if let cvc = lastSeguedToConcentrationViewController {
            //                cvc.theme = theme
            //                navigationController?.pushViewController(cvc, animated: true)
            //            } else {
            //                cvc.theme = theme
            //                navigationController?.pushViewController(cvc, animated: true)
            navigationController?.pushViewController(cvc, animated: true)
            
            //                performSegue(withIdentifier: "Choose Theme", sender: sender)
            //            }
        }
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        //Counter-intuitively, if we DO NOT want to collapse the secondary onto the primary, we have to return true.
        //In our situation, if a theme has been set, do the collapse (so we see the secondary). Otherwise, do not
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme != nil {
                return false
            }
        }
        return true
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "Choose Theme" {
    //            if let button = sender as? UIButton, let theme = getThemeFromButton(button) {
    //                if let cvc = segue.destination as? ConcentrationViewController {
    //                    cvc.theme = theme
    //                    lastSeguedToConcentrationViewController = cvc
    //                }
    //            }
    //        }
    //    }
    //
    //    private func getThemeFromButton(_ sender: UIButton) -> GameTheme? {
    //        //This is terrible behaviour. I'm identifying the theme to pick based off of the button's name, which makes the code very brittle. However, it will do for our purposes for the moment.
    //        if let themeName = sender.currentTitle {
    //            var theme: GameTheme
    //            switch themeName {
    //            case "Halloween":
    //                theme = .Halloween
    //            case "Sports":
    //                theme = .Sports
    //            case "Religion":
    //                theme = .Religion
    //            case "Japan":
    //                theme = .Japan
    //            default:
    //                theme = .Halloween
    //            }
    //            return theme
    //        }
    //        return nil
    //    }
    private func getThemeFromButton(_ sender: UIButton) -> Game? {
        //This is terrible behaviour. I'm identifying the theme to pick based off of the button's name, which makes the code very brittle. However, it will do for our purposes for the moment.
        let themeName = sender.currentTitle
        //            var theme: GameTheme
        var theme: Game
        let dataSource = DataSourse()
        
        theme = dataSource.existingGamesData[themeName!]!
        
        return theme
        //        }
        //        return nil
    }
    
}

