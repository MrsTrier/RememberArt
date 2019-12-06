//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Roman Cheremin on 03/12/2019.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var url: URL?
    @NSManaged public var artist: String?
    @NSManaged public var statusSpesial: Bool

}
