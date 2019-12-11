//
//  AvailableGame+CoreDataProperties.swift
//  RemembArt
//
//  Created by Roman Cheremin on 10/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//
//

import Foundation
import CoreData


extension AvailableGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvailableGame> {
        return NSFetchRequest<AvailableGame>(entityName: "AvailableGame")
    }

    @NSManaged public var gameDescription: String?
    @NSManaged public var gameName: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension AvailableGame {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: AvailableImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: AvailableImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
