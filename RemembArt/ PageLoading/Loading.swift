//
//  Loading.swift
//  RemembArt
//
//  Created by Roman Cheremin on 02/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

enum STLoadingStyle: String {

    case pacMan = "pac man"
}

class STLoadingGroup {
    fileprivate let loadingView: STLoadingable
    fileprivate var finish: STEmptyCallback?
    
    init(side: CGFloat, style: STLoadingStyle) {
        
        let bounds = CGRect(origin: .zero, size: CGSize(width: side, height: side))
        switch style {
        case .pacMan:
            loadingView = STPacManLoading(frame: bounds)
        }
    }
}

extension STLoadingGroup {
    var isLoading: Bool {
        return loadingView.isLoading
    }
    
    func startLoading() {
        loadingView.startLoading()
    }
    
    func stopLoading(finish: STEmptyCallback? = nil) {
        self.finish = finish
        loadingView.stopLoading(finish: finish)
    }
}

extension STLoadingGroup {
    func show(_ inView: UIView?, offset: CGPoint = .zero, autoHide: TimeInterval = 0) {
        guard let loadingView = loadingView as? UIView else {
            return
        }
        if loadingView.superview != nil {
            loadingView.removeFromSuperview()
        }
        var showInView = UIApplication.shared.keyWindow ?? UIView()
        if let inView = inView {
            showInView = inView
        }
        let showInViewSize = showInView.frame.size
        loadingView.center = CGPoint(x: showInViewSize.width * 0.5, y: showInViewSize.height * 0.5)
        showInView.addSubview(loadingView)
    }
    
    func remove() {
        guard let loadingView = loadingView as? UIView else {
            return
        }
        if loadingView.superview != nil {
            stopLoading() {
                loadingView.removeFromSuperview()
            }
        }
    }
}
