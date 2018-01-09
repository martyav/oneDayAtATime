//
//  ListItem.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

struct ListItem: Codable {
    let title: String
    var checkedOff: Bool = false
}
