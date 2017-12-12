//
//  Constants.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

struct Identifier {
    private init() {}
    
    static let listMakerCell = "listMakerCell"
    static let storedListCell = "storedListCell"
    static let profileSectionHeader = "profileSectionHeader"
    static let todaySectionHeader = "todaySectionHeader"
    static let todayVCToListMakerVC = "todayVCToListMakerVC"
}

enum Key: String {
    case week1
    case week2
    case week3
    case week4
}

struct WeekDayNames {
    private init() {}
    
    static let short = CurrentTime.shared.weekDayNamesShort()
    static let initials = CurrentTime.shared.weekDayNamesInitials()
}
