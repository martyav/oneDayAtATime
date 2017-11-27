//
//  Week.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class Week: Codable {
    var monday: List?
    var tuesday: List?
    var wednesday: List?
    var thursday: List?
    var friday: List?
    var saturday: List?
    var sunday: List?
    
    required init(mon: List?, tue: List?, wed: List?, thu: List?, fri: List?, sat: List?, sun: List?) {
        self.monday = mon
        self.tuesday = tue
        self.wednesday = wed
        self.thursday = thu
        self.friday = fri
        self.saturday = sat
        self.sunday = sun
    }
}
