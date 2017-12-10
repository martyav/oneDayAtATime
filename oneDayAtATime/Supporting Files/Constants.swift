//
//  Constants.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class Constants {
    static let shared = Constants()
    
    private init() {}
    
    let listMakerCellIdentifier = "listMakerCell"
    let storedListCellIdentifier = "storedListCell"
    let profileSectionHeader = "profileHeader"
    let todaySectionHeader = "todayHeader"
    
    let todayToListMakerSegueIdentifier = "todayToListMaker"
    
    let weekDayNames = CurrentTime.shared.weekDayNames()
    let weekDayInitials = CurrentTime.shared.dayOfWeek()
}
