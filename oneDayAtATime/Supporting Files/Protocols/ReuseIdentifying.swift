//
//  ReuseIdentifying.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/12/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

// credit to https://medium.com/bleeding-edge/nicer-reuse-identifiers-with-protocols-in-swift-97d18de1b2df

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
