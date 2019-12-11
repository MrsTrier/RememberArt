//
//  AvailableImage+CoreDataProperties.swift
//  RemembArt
//
//  Created by Roman Cheremin on 10/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//
//

import Foundation
import CoreData


extension AvailableImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvailableImage> {
        return NSFetchRequest<AvailableImage>(entityName: "AvailableImage")
    }

    @NSManaged public var artist: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var imageName: String?
    @NSManaged public var url: URL?
    @NSManaged public var png: NSData?
    @NSManaged public var game: AvailableGame?

}
