//
//  CreateGameViewController.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate {
    
//    let popUpViewBuilder = LocalNotificationBuilder()
    
    var data = DataSource()
    
    var dictionaryWithSelectedCells : [IndexPath : Bool] = [:]
    
    enum Mode {
        case view
        case select
    }
    
    var viewMode: Mode = .view {
        didSet {
            switch viewMode {
            case .view:
                collectionView.allowsMultipleSelection = false
            case .select:
                collectionView.allowsMultipleSelection = true
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
    
    let collectionView: UICollectionView = {
        let layout = ISSCustomLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red:0.27, green:0.46, blue:0.58, alpha:1.0)
        collectionView.dragInteractionEnabled = true
        collectionView.register(ISSMenuCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = data
        view.backgroundColor = .white
        
        //navigation bar setup
        self.title = "Art Gallery"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        
        // columns' title creation
        let headerView = createHeader(point: topDistance)
        
        // collection view frame setup
        let collectionViewPoint = topDistance + headerView.frame.height
        collectionView.frame = CGRect(x: 0, y: collectionViewPoint, width: view.frame.width, height: view.frame.height - collectionViewPoint)
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(headerView)
    }


//    private func makePopUpView() -> UIView {
//        return popUpViewBuilder
//            .reset()
//            .build(badge: 1)
//            .build(title: "Notification Title")
//            .build(subtitle: "Subtitle")
//            .build(body: "Body custom text")
//            .result()
//    }
    
    
}


extension CreateGameViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.arrayOfImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! ISSMenuCollectionViewCell
        cell.backgroundColor = .green;
        cell.picture.image = UIImage(named: data.arrayOfImg[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewMode {
        case .view:
            return
        case .select:
            let cell = collectionView.cellForItem(at: indexPath)
            let makevisible = cell?.contentView.viewWithTag(21)
            makevisible?.alpha = 1
            dictionaryWithSelectedCells[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if viewMode == .select {
            let mycell = collectionView.cellForItem(at: indexPath)
            let remove = mycell?.contentView.viewWithTag(21)
            remove?.alpha = 0
            dictionaryWithSelectedCells[indexPath] = false
        }
    }
}


extension CreateGameViewController {
    
    @objc func cancelButtonTapped() {
        viewMode = .view
        collectionView.dragInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItems = nil
        //        for section in 0..<(arrayOfImg.count) {
        //            for cell in 0..<(data.items[section].count) {
        //                let mycell = collectionView.cellForItem(at: IndexPath(row: cell, section: section))
        //                let hide = mycell?.contentView.viewWithTag(21)
        //                hide?.alpha = 0
        //            }
        //        }
        dictionaryWithSelectedCells.removeAll()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
    }
    
    @objc func selectButtonTapped() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        collectionView.allowsMultipleSelection = true
        let createGameButton = UIButton()
        createGameButton.setTitle("Create game", for: .normal)
        createGameButton.addTarget(self, action: #selector(createGameButtonTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: createGameButton), UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))]
        viewMode = .select
    }
    
    @objc func createGameButtonTapped() {
        if dictionaryWithSelectedCells.count != 10 {
            //popupView об ошибке с сообщением "Please, choose additional \(10 - dictionaryWithSelectedCells.count) pictures"
            
            
        } else {
            //игра сохраняется и отправляется в базу данных
        }
    }
}


extension CreateGameViewController {
    
    
    func createHeader(point safeAreaPoint: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint, width: view.frame.width, height: 70))
        headerView.axis = .vertical
        headerView.distribution = .fillEqually
        
        let toDoLabel = UILabel()
        toDoLabel.textColor = UIColor(red:0.02, green:0.03, blue:0.18, alpha:1.0)
        toDoLabel.layer.cornerRadius = 10.0
        toDoLabel.textAlignment = .center
        toDoLabel.text = "Tap \"select\" to create a new game"
        
        let filter = UIButton()
        filter.setTitle("Filter artworks 📇", for: .normal)
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
        var cvc = LoadImageFromGalleryViewController()
        navigationController?.pushViewController(cvc, animated: true)
    }
    
}
