//
//  InteractorForLoadImageView.swift
//  RemembArt
//
//  Created by Roman Cheremin on 09/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

protocol CleanSwiftBusinessLogic: class {
    func saveImage(request: CleanSwift.ImageData.Request)
    func showGallery(request: CleanSwift.ImageData.Request)
    func setImage(request: CleanSwift.ImageData.Request)
    func clearCache()
}

protocol CleanSwiftDataStore {
    var image: UIImage? { get set }
}

class InteractorForLoadImageView: NSObject, CleanSwiftBusinessLogic, CleanSwiftDataStore {
    
    var imagePickerController = UIImagePickerController()

    func saveImage(request: CleanSwift.ImageData.Request) {
        
    }
    
    var presenter: CleanSwiftPresentationLogic?
    var image: UIImage?
    
    // MARK: работа с изображением
    
    func getImage(request: CleanSwift.ImageData.Request) {
       
        
    }
    
    func setImage(request: CleanSwift.ImageData.Request) {
        let response = CleanSwift.ImageData.Response(image: image)
        presenter?.presentImage(response: response)
    }
    
    func clearCache() {
        image = nil
        presenter?.clearImage()
    }
}


extension InteractorForLoadImageView:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    func showGallery(request: CleanSwift.ImageData.Request) {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        presenter?.imagePicker(imagePickerController)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let response = CleanSwift.ImageData.Response(image: image)
            presenter?.presentImage(response: response)
        }
    }
}
