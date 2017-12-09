//
//  CurrentTime.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/09/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class CurrentTime {
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    static let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    func weekOfMonth() -> Int {
        return CurrentTime.calendar.component(.weekOfMonth, from: self.todaysDate)
    }
    
    func dayOfWeek() -> String {
        dateFormatter.dateFormat = "E" // E tells the formatter to return an abbreviated weekday: Sun, Mon, Tue, etc
        return dateFormatter.string(from: todaysDate)
    }
    
    static func weekDayNames() -> [String] {
        return CurrentTime.calendar.shortStandaloneWeekdaySymbols
    }
}
