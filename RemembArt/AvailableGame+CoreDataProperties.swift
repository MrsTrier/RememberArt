//
//  AvailableGame+CoreDataProperties.swift
//  RemembArt
//
//  Created by Roman Cheremin on 07/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//
//

import Foundation
import CoreData


extension AvailableGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvailableGame> {
        return NSFetchRequest<AvailableGame>(entityName: "AvailableGame")
    }

    @NSManaged public var gameName: String?
    @NSManaged public var gameDescription: String?
    @NSManaged public var images: NSSet?

    
    public var wrappedGameName: String {
        return gameName ?? "Unknown game name"
    }
    
    public var wrappedGameDescription: String {
        return gameDescription ?? "Unknown game description"
    }
    
    public var imageArray: [AvailableImage] {
        let set = images as? Set<AvailableImage> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
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
