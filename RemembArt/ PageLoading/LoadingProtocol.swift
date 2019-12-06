//
//  LoadingProtocol.swift
//  RemembArt
//
//  Created by Roman Cheremin on 02/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

typealias STEmptyCallback = () -> ()

protocol STLoadingable {
    var isLoading: Bool { get }
    
    func startLoading()
    func stopLoading(finish: STEmptyCallback?)
}

protocol STLoadingConfig {
    var animationDuration: TimeInterval { get }
    var lineWidth: CGFloat { get }
    var loadingTintColor: UIColor { get }
}
