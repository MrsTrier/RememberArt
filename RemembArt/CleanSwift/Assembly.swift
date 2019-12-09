//
//  Assembly.swift
//  RemembArt
//
//  Created by Roman Cheremin on 09/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class Assembly {
    func viewController(_ vc: LoadImageFromGalleryViewController) {
        let presenter = PresenterForLoadImageView()
        let interactor = InteractorForLoadImageView()
        
        presenter.interactor = interactor
        presenter.viewController = vc
        vc.presenter = presenter
        
    }
}
