//
//  ViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 02/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HolderViewDelegate {
    
    var holderView = HolderView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        holderView.addOval()
        addButton()

        view.addSubview(holderView)
    }
    
    func animateLabel() {
        
    }
    
    func addButton() {
        let button = UIButton()
        button.backgroundColor = .blue
        button.frame = CGRect(x: 100.0, y: 100.0, width: 50, height: 30)
        button.addTarget(self, action: #selector(buttonPressed(_ :)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func buttonPressed(_ sender: UIButton!) {
        view.backgroundColor = Colors.white
        view.subviews.map({ $0.removeFromSuperview() })
        holderView = HolderView(frame: .zero)
        addHolderView()
    }
}

