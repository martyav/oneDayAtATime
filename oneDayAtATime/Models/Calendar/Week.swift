//
//  Week.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class Week: Codable {
    var monday: Checklist?
    var tuesday: Checklist?
    var wednesday: Checklist?
    var thursday: Checklist?
    var friday: Checklist?
    var saturday: Checklist?
    var sunday: Checklist?
    
    required init(mon: Checklist?, tue: Checklist?, wed: Checklist?, thu: Checklist?, fri: Checklist?, sat: Checklist?, sun: Checklist?) {
        self.monday = mon
        self.tuesday = tue
        self.wednesday = wed
        self.thursday = thu
        self.friday = fri
        self.saturday = sat
        self.sunday = sun
    }
}
