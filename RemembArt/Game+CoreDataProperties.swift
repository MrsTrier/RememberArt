//
//  Game+CoreDataProperties.swift
//  RemembArt
//
//  Created by Roman Cheremin on 03/12/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var gameDescription: String?
    @NSManaged public var gameName: String?
    @NSManaged public var setOfImages: NSObject?
    @NSManaged public var image: AvailableImage?

}
