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
    
    var todaysDate: Date {
        get {
            return Date()
        }
    }
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    var dayOfWeek: String {
        dateFormatter.dateFormat = "E" // E tells the formatter to return an abbreviated weekday: Sun, Mon, Tue, etc
        return dateFormatter.string(from: todaysDate)
    }
    
    func weekOfMonth() -> Int {
        return self.calendar.component(Calendar.Component.weekOfMonth, from: self.todaysDate)
    }
    
    func appleWtf() {
        print(self.calendar.shortStandaloneWeekdaySymbols == self.calendar.standaloneWeekdaySymbols)
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
