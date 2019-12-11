//
//  LoadImageFromGalleryViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 09/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit


protocol ImageImportProtocol {
    func reloadCollection(append: Image)
    
}

protocol CleanSwiftDisplayLogic: class {
    func displayImage(viewModel: CleanSwift.ImageData.ViewModel)
    func showImagePickerView(_ imagePickerController: UIImagePickerController)
//    func showAlert()
}

class LoadImageFromGalleryViewController: UIViewController, CleanSwiftDisplayLogic {

    var interactor: CleanSwiftBusinessLogic?
    var presenter: CleanSwiftPresentationLogic?
    var delegate: ImageImportProtocol?
    
    let imageView = UIImageView()
    let nameTextField = UITextField()
    let artistTextField = UITextField()
    let descriptionTextField = UITextField()
    let galleryButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .custom)
    
    var helper = Utilities()
    var imageFromUser: Image?
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup
    func setup() {
        let presenter = PresenterForLoadImageView()
        let interactor = InteractorForLoadImageView()
        
        interactor.presenter = presenter
        self.interactor = interactor
        presenter.interactor = interactor
        presenter.viewController = self
        self.presenter = presenter
    }
    
    func buildView() {
        
        imageView.frame = CGRect(x: 30, y: 290, width: view.frame.width - 60, height: 150)
        imageView.image = UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFill
        
        nameTextField.frame = CGRect(x: 30, y: 570, width: view.frame.width - 60, height: 50)
        nameTextField.placeholder = "Name of art masterpiece"
        helper.styleTextField(nameTextField)
        
        artistTextField.frame = CGRect(x: 30, y: 630, width: view.frame.width - 60, height: 50)
        artistTextField.placeholder = "Author of art masterpiece"
        helper.styleTextField(artistTextField)
        
        descriptionTextField.frame = CGRect(x: 30, y: 690, width: view.frame.width - 60, height: 50)
        descriptionTextField.placeholder = "Description of art masterpiece"
        helper.styleTextField(descriptionTextField)

        galleryButton.frame = CGRect(x: 30, y: 130, width: view.frame.width - 60, height: 50)
        galleryButton.setTitle("Image from gallery", for: .normal)
        galleryButton.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        helper.styleFilledButton(galleryButton)
        
        saveButton.frame = CGRect(x: 30, y: 760, width: view.frame.width - 60, height: 50)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        helper.styleHollowButton(saveButton)

        cancelButton.frame = CGRect(x: 30, y: 820, width: view.frame.width - 60, height: 50)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        helper.styleHollowButton(cancelButton)

        view.addSubview(galleryButton)
        view.addSubview(imageView)
        view.addSubview(nameTextField)
        view.addSubview(artistTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
//    func showAlert() {
//        if let alert = router?.setupAlert() {
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            print("There are no image! Please, download it first")
//        }
//    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // настройка представления
        buildView()
    }
    
    // MARK: работа с изображением
    
    func showImagePickerView(_ imagePickerController: UIImagePickerController) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func getImage()
    {
        let request = CleanSwift.ImageData.Request()
        interactor?.showGallery(request: request)
    }
    
    @objc func setImage() {
//        let request = CleanSwift.ImageData.Request()
//        interactor?.setImage(request: request)
    }
    
    func displayImage(viewModel: CleanSwift.ImageData.ViewModel)
    {
        imageView.image = viewModel.image
        imageView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clearCache() {
        interactor?.clearCache()
    }

}


extension LoadImageFromGalleryViewController: PopUpViewProtocol {
    @objc func saveButtonTapped() {
        if (helper.fieldValidation(nameTextField) != nil) ||  (helper.fieldValidation(artistTextField) != nil) {
//            resultView("Please, fill name of the image and name of the artist")
            return
        } else {
            if let image = imageView.image {
                if imageView.image != UIImage(named: "noImage") {
                    imageFromUser = Image(name: nameTextField.text!, artist: artistTextField.text!, description: descriptionTextField.text!, url: nil, png: image)
                    CoreDataStack.shared.saveImage(imageFromUser!)
                    let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "congratulation")!, andType: ["standart", "You saved your image"])
                    
                    popUpView.frame = view.frame
                    popUpView.delegate = self
                    popUpView.makeVisible()
                    view.addSubview(popUpView)
                    NotificationCenter.default.addObserver(self, selector: #selector(resultView), name: NSNotification.Name(rawValue: "UserImageSaved"), object: nil)
                } else {
                    //Ты не добавил своей картинки!
                }
            }
        }
    }
    
    @objc func resultView() {
        delegate?.reloadCollection(append: imageFromUser!)
        
        //PopUpView Import Compleated Sucsessfuly
    }
}


