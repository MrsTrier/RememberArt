//
//  Card.swift
//  RemembArt
//
//  Created by Roman Cheremin on 28/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import Foundation

struct Card
{
    var isMatched = false
    var isFaceUp = false
    var hasBeenFlippedAtLeastOnce = false
    private let identifier: Int
    private static var identifierFactory = 0
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}

extension Card: Hashable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var hashValue: Int {
        return identifier;
    }
}
