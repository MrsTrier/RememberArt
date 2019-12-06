//
//  Image+CoreDataClass.swift
//  
//
//  Created by Roman Cheremin on 03/12/2019.
//
//

import Foundation
import CoreData


@objc(Image)
internal class Image: NSManagedObject {
    @NSManaged public var imageName: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var url: URL?
    @NSManaged public var artist: String?
    @NSManaged public var statusSpesial: Bool
}
