//
//  CreateGameViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UICollectionViewDataSource, UIPickerViewDelegate {
        
    let layout = ISSCustomLayout()

    var collectionView: UICollectionView?

    var images: [Image] = []
    private var avImages = [AvailableImage]()

    private let stack = CoreDataStack.shared
    var utils = Utilities()
    
    var dataForFutureGame : [IndexPath : Image] = [:]
    var dictionaryWithSelectedCells : [IndexPath : Image] = [:]
    
    enum Mode {
        case view
        case select
    }
    
    var viewMode: Mode = .view {
        didSet {
            switch viewMode {
            case .view:
                collectionView!.allowsMultipleSelection = false
            case .select:
                collectionView!.allowsMultipleSelection = true
            }
        }
    }
    
    var pickerView = UIPickerView()
    
    var styler = Utilities()

    /// Calculate where navigation bar ends
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.addSubview(collectionView!)
//        view.addSubview(headerView)
//        collectionView!.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        avImages = stack.loadFromMemoryImages()
        downloadPng(for:avImages)
        
        pickerView.delegate = self
//        pickerView.dataSource =  //fix!!!!!!
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView!.backgroundColor = .white
        collectionView!.register(ISSMenuCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        //navigation bar setup
        self.title = "Art Gallery"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }

    
    
    func downloadPng(for imagesToConvert: [AvailableImage]) {
        utils.pngFromUrl(for: imagesToConvert)
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionView), name: NSNotification.Name(rawValue: "ImagesForGameLoaded"), object: nil)
    }

    @objc func loadCollectionView() {
        images = utils.returnPng()
        let headerView = createHeader(point: topDistance)

        let collectionViewPoint = topDistance + headerView.frame.height
        collectionView!.frame = CGRect(x: 0, y: collectionViewPoint, width: view.frame.width, height: view.frame.height - collectionViewPoint)
        collectionView!.allowsMultipleSelection = false
        collectionView!.delegate = self
        collectionView?.dataSource = self
        
        view.addSubview(headerView)
    }
}


extension CreateGameViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! ISSMenuCollectionViewCell
        cell.picture.image = images[indexPath.row].png!
        dataForFutureGame[indexPath] = images[indexPath.row]
        let makevisible = cell.contentView.viewWithTag(21)
        if let index = dictionaryWithSelectedCells.index(forKey: indexPath) {
            makevisible?.alpha = 1
        } else {
            makevisible?.alpha = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewMode {
            case .view:
                return
            case .select:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! ISSMenuCollectionViewCell
                let cellview = collectionView.cellForItem(at: indexPath)
                let makevisible = cellview!.contentView.viewWithTag(21)
                makevisible?.alpha = 1
                dictionaryWithSelectedCells[indexPath] = dataForFutureGame[indexPath]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if viewMode == .select {
            let mycell = collectionView.cellForItem(at: indexPath)
            let remove = mycell?.contentView.viewWithTag(21)
            remove?.alpha = 0
            dictionaryWithSelectedCells[indexPath] = nil
        }
    }
}


extension CreateGameViewController: PopUpViewProtocol {
    func userWantsCreateGame(withName name: String, desc: String) {
        if name == "" || desc == "" {
            let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "try-again")!, andType: ["ng", "error", "You mised some fields"])
            popUpView.delegate = self
            popUpView.makeVisible()
            view.addSubview(popUpView)
        } else {
            let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "congratulation")!, andType: ["standart", "You made a new game"])
            popUpView.delegate = self
            popUpView.makeVisible()
            view.addSubview(popUpView)
            // CoreData
            var imgForGame = Array(dictionaryWithSelectedCells.values)
            var game = Game(name: name, description: desc, boardColor: UIColor(red:0.04, green:0.17, blue:0.44, alpha:1.0), cardColor: .white, imagesForGame: imgForGame)
            stack.saveUserGame(game)
        }
    }
    
    @objc func cancelButtonTapped() {
        if viewMode == .view {
            let  startvc =  self.navigationController?.viewControllers.filter({$0 is StartView}).first
            let  authvc =  self.navigationController?.viewControllers.filter({$0 is AuthoriseUserViewController}).first
            navigationController?.popToViewController(startvc ?? authvc!, animated: true)
        } else {
            self.navigationItem.leftBarButtonItems = nil
            for cell in 0..<(images.count) {
                let mycell = collectionView!.cellForItem(at: IndexPath(row: cell, section: 0))
                let hide = mycell?.contentView.viewWithTag(21)
                hide?.alpha = 0
            }
            dictionaryWithSelectedCells.removeAll()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
            viewMode = .view
        }
    }
    
    @objc func selectButtonTapped() {
        collectionView!.allowsMultipleSelection = true
        let createGameButton = UIButton()
        createGameButton.setTitle(" Create game ", for: .normal)
        styler.styleFilledButton(createGameButton)
        createGameButton.addTarget(self, action: #selector(createGameButtonTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createGameButton)
        viewMode = .select
    }
    
    @objc func createGameButtonTapped() {
        if dictionaryWithSelectedCells.count != 10 {
            var error = ""
            if dictionaryWithSelectedCells.count < 10 {
                error = "Choose \(10 - dictionaryWithSelectedCells.count) additional artworks. Now you selected \(dictionaryWithSelectedCells.count)/10"
            } else {
                error = "Deselect \(dictionaryWithSelectedCells.count - 10) artworks. Now you selected too many for one game \(dictionaryWithSelectedCells.count)"
            }
            let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "try-again")!, andType: ["ng", "error", error])
            popUpView.delegate = self
            popUpView.makeVisible()
            view.addSubview(popUpView)
            //popupView об ошибке с сообщением "Please, choose additional \(10 - dictionaryWithSelectedCells.count) pictures"
            
        } else {
            let popUpView = PopUpView(frame: view.frame, andImage: UIImage(named: "congratulation")!, andType: ["ng", "You are about to make a new game"])
            popUpView.delegate = self
            popUpView.makeVisible()
            view.addSubview(popUpView)
            //игра сохраняется и отправляется в базу данных
        }
    }
}


extension CreateGameViewController {
    
    func createHeader(point safeAreaPoint: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint, width: view.frame.width, height: 180))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        headerView.spacing = 10.0
        
        let toDoLabel = UILabel()
        toDoLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        toDoLabel.layer.cornerRadius = 10.0
        toDoLabel.textAlignment = .center
        toDoLabel.text = "Tap \"select\" to create a new game"
        toDoLabel.font = UIFont(name: "Copperplate-Bold", size: 20)

        let filter = UIButton()
        filter.setTitle("Filter artworks", for: .normal)
        filter.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        styler.styleFilledButton(filter)

        let excessGallery = UIButton()
        excessGallery.setTitle("Add image", for: .normal)
        excessGallery.addTarget(self, action: #selector(excessGalleryTapped), for: .touchUpInside)
        styler.styleFilledButton(excessGallery)

        headerView.addArrangedSubview(toDoLabel)
        headerView.addArrangedSubview(filter)
        headerView.addArrangedSubview(excessGallery)
        
        return headerView
    }
    
    @objc func filterTapped() {
        
    }
    
    @objc func excessGalleryTapped() {
        let cvc = LoadImageFromGalleryViewController()
        cvc.delegate = self
        navigationController?.pushViewController(cvc, animated: true)
    }
    
}


extension CreateGameViewController: ImageImportProtocol {
    func reloadCollection(append image: Image) {
        
        DispatchQueue.main.async {
            self.images.append(image)
            let indexPaths = IndexPath(item: 0, section: 0)
            self.collectionView!.insertItems(at: [indexPaths])
        }
    }
    
    
}
