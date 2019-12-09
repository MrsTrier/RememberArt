//
//  LayoutForCollectionView.swift
//  RemembArt
//
//  Created by Roman Cheremin on 08/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit
// 1)
protocol ISSCustomLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class ISSCustomLayout: UICollectionViewLayout {
    
    // Сохраняем ссылку на делегата
    weak var delegate: ISSCustomLayoutDelegate?
    
    // Свойства настройки отображения - количество колонок и отступы
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    // Массив для хранения вычисленных аттрибутов. В методе prepare() параметры аттрибутов вычисляются для всех item'ов и хранятся в этом массиве. А в дальнейшем мы будем просто брать эти параметры их массива и не пересчитывать их
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    // Переменные для хранения размера контента. Добавили фото - увеличи параметр высоты, ширина - вычисляемое на основе ширины collectionView и инсетов
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // возвращает размер контента collectionView
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // данных в layoutAttributes нет
        guard
            layoutAttributes.isEmpty == true,
            let collectionView = collectionView
            else {
                return
        }
        // Задаем значения ширины и отступов
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // Итеративно идем по всем item'ам collectionView
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // С помощью метода делегата получаем высоту картинки
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Создаем аттрибуты для указанного indexPath
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributes.append(attributes)
            
            //
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Итеративно проходим по массиву аттрибутов и ищем элементы внутри rect
        for attributes in layoutAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}

