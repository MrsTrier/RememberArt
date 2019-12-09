//
//  PresenterForLoadImageView.swift
//  RemembArt
//
//  Created by Roman Cheremin on 09/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

protocol CleanSwiftPresentationLogic {
    func imagePicker(_ imagePickerController: UIImagePickerController)
    func presentImage(response: CleanSwift.ImageData.Response)
    func clearImage()
}

class PresenterForLoadImageView: CleanSwiftPresentationLogic {
    
    func imagePicker(_ imagePickerController: UIImagePickerController) {
        viewController?.showImagePickerView(imagePickerController)

    }
    
    weak var interactor: CleanSwiftBusinessLogic?
    weak var viewController: CleanSwiftDisplayLogic?
    
    // MARK: работа с картинкой
    
    func presentImage(response: CleanSwift.ImageData.Response) {
        
        if let image = response.image  {
            let viewModel = CleanSwift.ImageData.ViewModel(image: image)
            viewController?.displayImage(viewModel: viewModel)
        } else {
//            viewController?.showAlert()
        }
    }
    
    func clearImage() {
        let viewModel = CleanSwift.ImageData.ViewModel(image: nil)
        viewController?.displayImage(viewModel: viewModel)
    }
    
}
