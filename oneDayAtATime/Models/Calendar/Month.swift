//
//  Month.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class Month: Codable {
    var week1: Week
    var week2: Week
    var week3: Week
    var week4: Week
    
    required init(week1: Week, week2: Week, week3: Week, week4: Week) {
        self.week1 = week1
        self.week2 = week2
        self.week3 = week3
        self.week4 = week4
    }
}
