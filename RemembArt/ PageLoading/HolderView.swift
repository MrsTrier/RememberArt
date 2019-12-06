//
//  HolderView.swift
//  RemembArt
//
//  Created by Roman Cheremin on 02/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
    func animateLabel()
}

class HolderView: UIView {
    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    
    var parentFrame: CGRect = .zero
    weak var delegate: HolderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.clear
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(wobbleOval),
                                               userInfo: nil, repeats: false) 
    }
    
    @objc func wobbleOval() {
        layer.addSublayer(triangleLayer)
        ovalLayer.wobble()
        

        Timer.scheduledTimer(timeInterval: 0.9, target: self,
                                             selector: #selector(drawAnimatedTriangle), userInfo: nil,
                                               repeats: false)
    }
    
    @objc func drawAnimatedTriangle() {
        triangleLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(spinAndTransform),
                                               userInfo: nil, repeats: false)
    }
    
    
    @objc func spinAndTransform() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI * 45.0)
        rotationAnimation.duration = 10
        rotationAnimation.isRemovedOnCompletion = true
        layer.add(rotationAnimation, forKey: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(loadList(rotationAnimation: rotationAnimation)), name: NSNotification.Name(rawValue: "DocumentReceived"), object: nil)
    }
    @objc func loadList(rotationAnimation: CABasicAnimation) {
        
    }
}
