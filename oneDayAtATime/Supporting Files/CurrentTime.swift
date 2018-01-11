//
//  CurrentTime.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/09/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class CurrentTime {
    static let shared = CurrentTime()
    
    private init() {
        self.dateFormatter.locale = Locale.autoupdatingCurrent
    }
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    var todaysDate: Date {
        return Date()
    }
    
    var dayOfWeek: String {
        dateFormatter.dateFormat = "E" // E tells the formatter to return an abbreviated weekday: Sun, Mon, Tue, etc
        return dateFormatter.string(from: todaysDate)
    }
    
    var weekOfMonth: Int {
        return self.calendar.component(Calendar.Component.weekOfMonth, from: self.todaysDate)
    }
    
    var daysInFirstWeek: Int {
        return 7 - self.calendar.firstWeekday
    }
    
    var daysInMonth: Int {
        let rangeOfDays = self.calendar.range(of: .day, in: .month, for: self.todaysDate)!
        
        return rangeOfDays.count
    }
    
    var weeksInMonth: Int {
        let baseline = 4
        let difference = 7 - self.daysInFirstWeek
        let remainder = self.daysInMonth % 28
        
        guard remainder != 0 && difference != 0 else {
            return baseline
        }
        
        if difference + remainder <= 7 {
            return baseline + 1
        }
        
        return baseline + 2
    }
    
    func weekDayNamesInitials() -> [String] {
        return self.calendar.veryShortStandaloneWeekdaySymbols
    }
    
    func weekDayNamesShort() -> [String] {
        return self.calendar.shortStandaloneWeekdaySymbols
    }
    
    func weekDayNamesLong() -> [String] {
        // there is a bizarre bug with standalone symbols -- it is identical to shortStandaloneWeekdaySymbols
       // return self.calendar.standaloneWeekdaySymbols
        return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }
}
