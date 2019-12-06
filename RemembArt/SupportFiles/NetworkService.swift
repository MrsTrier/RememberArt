//
//  NetworkService.swift
//  RemembArt
//
//  Created by Roman Cheremin on 05/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

protocol NetworkServiceProtocol: class {
    
    func downloadImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void)
}

class NetworkService: NSObject, NetworkServiceProtocol {
    
    func downloadImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let currentError = error {
                completion(nil, currentError)
                return
            }
            
            guard let currentData = data else { return }
            let image = UIImage(data: currentData)
            completion(image, nil)
        }
        
        task.resume()
    }
}
