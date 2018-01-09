//
//  CurrentList.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/07/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

enum ScheduleError: Error {
    case monthIsFull
    case dayHasNoValidList // day == nil
    case weekHasNoValidDays // all keys are nil -- week is empty
    case weekDoesNotExist // index exceeds month.count
    case monthHasNoValidWeeks // all indices are nil
}

class ListManager {
    
}


