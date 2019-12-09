//
//  CleanSwiftForLoadImageView.swift
//  RemembArt
//
//  Created by Roman Cheremin on 09/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

enum CleanSwift {
    // MARK: Use cases
    
    enum ImageData {
        struct Request {
        }
        struct Response {
            var image: UIImage?
        }
        struct ViewModel {
            var image: UIImage?
        }
    }
}
