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
    func build(body: String) -> Self
    
    @discardableResult
    func build(badge: Int) -> Self
    
    @discardableResult
    func build(category: String) -> Self
    
    @discardableResult
    func reset() -> Self
    
    func result() -> UIView
}


final class LocalPopUpViewBuilder {
    
    private var popUpView = UIView()
}

extension LocalPopUpViewBuilder: PopUpViewBuilder {
    
    func build(title: String) -> LocalPopUpViewBuilder {
//        currentNotification.title = title
        return self
    }
    
    func build(subtitle: String) -> LocalPopUpViewBuilder {
//        currentNotification.subtitle = subtitle
        return self
    }
    
    func build(body: String) -> LocalPopUpViewBuilder {
//        currentNotification.body = body
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
        popUpView = UIView()
        return self
    }
    
    func result() -> UIView {
        return popUpView.copy() as? UIView ?? UIView()
    }
}
