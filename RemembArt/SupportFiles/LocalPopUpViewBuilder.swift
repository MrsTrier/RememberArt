//
//  LocalPopUpViewBuilder.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import Foundation

protocol PopUpViewBuilder: AnyObject {
    
    @discardableResult
    func build(title: String) -> Self
    
    @discardableResult
    func build(subtitle: String) -> Self
    
    @discardableResult
    func build(delegate: UIViewController) -> Self
    
    @discardableResult
    func build(buttons: [UIButton]) -> Self
    
    @discardableResult
    func build(badge: Int) -> Self
    
    @discardableResult
    func build(category: String) -> Self
    
    @discardableResult
    func reset() -> Self
    
    func result() -> PopUpView
}


final class LocalPopUpViewBuilder {
    
    var popUpView: PopUpView
    UIView
    
    init(_ frame: CGRect, imageName: String) {
        popUpView = PopUpView(frame: frame, andImage: UIImage(named: imageName)!)
    }

}

extension LocalPopUpViewBuilder: PopUpViewBuilder {
    
    
    func build(title: String) -> LocalPopUpViewBuilder {
        return self
    }
    
    func build(delegate: UIViewController) -> LocalPopUpViewBuilder {
        popUpView.delegate = delegate as! PopUpViewProtocol
        return self
    }
    
    
    func build(subtitle: String) -> LocalPopUpViewBuilder {
//        currentNotification.subtitle = subtitle
        return self
    }
    
    func build(buttons: [UIButton]) -> LocalPopUpViewBuilder {
        
        for but in buttons {
            popUpView.addSubview(but)
        }
        return self
    }
    
    func build(badge: Int) -> LocalPopUpViewBuilder {
//        currentNotification.badge = NSNumber(value: badge)
        return self
    }
    
    func build(category: String) -> LocalPopUpViewBuilder {
//        currentNotification.categoryIdentifier = category
        return self
    }
    
    func reset() -> LocalPopUpViewBuilder {
        popUpView = UIView() as! PopUpView
        return self
    }
    
    

    
    func result() -> PopUpView {
        return popUpView
    }
}
