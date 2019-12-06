//
//  AvailableGame+CoreDataProperties.swift
//  RemembArt
//
//  Created by Roman Cheremin on 03/12/2019.
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
    @NSManaged public var setOfImages: NSObject?
    @NSManaged public var gameDescription: String?
    @NSManaged public var image: AvailableImage?

}
