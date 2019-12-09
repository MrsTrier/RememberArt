//
//  Utilities.swift
//  RemembArt
//
//  Created by Roman Cheremin on 29/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class Utilities {
    
    func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0)
        button.layer.cornerRadius = 15.0
        button.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)

//        button.tintColor = UIColor.white
    }
    
    func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0).cgColor
        button.setTitleColor(UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate-Bold", size: 20)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
