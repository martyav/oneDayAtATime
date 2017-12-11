//
//  CurrentList.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/07/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

class ListManager {
    let defaults: UserDefaults
    let todaysDate: Date
    private var currentDayOfWeek: String
    private var currentWeek: Week?
    private var currentMonth: Month?
    
    init() {
        self.defaults = UserDefaults.standard
        self.todaysDate = CurrentTime.shared.todaysDate
        self.currentMonth = defaults.array(forKey: "currentMonth") as? Month
        self.currentWeek = currentMonth?[CurrentTime.shared.weekOfMonth()]
        self.currentDayOfWeek = CurrentTime.shared.dayOfWeek()
    }
    
    func checkDay() -> String {
        return self.currentDayOfWeek
    }
    
    func checkWeek() -> Week? {
        return self.currentWeek
    }
    
    func checkMonth() -> Month? {
        return self.currentMonth
    }
    
//    func update(list: Checklist) {
//        if self.currentWeek == nil {
//            self.currentWeek = Week()
//        }
//
//        self.currentWeek![self.currentDayOfWeek] = list
//    }
//
//    func update(day: String) {
//        self.currentDayOfWeek = day
//    }
//
//    func update(week: Week) {
//        self.currentWeek = week
//    }
//
//    func update(month: Month) {
//        self.currentMonth = month
//    }
//
//    func update(list: Checklist, onDay day: String, forWeek week: Week) {
//        self.update(week: week)
//        self.currentWeek![day] = list
//    }
//
//    func update(week: Week, atIndex index: Int) {
//        guard index < 5  && index > 0 else {
//            return
//        }
//
//        self.update(week: week)
//
//        if self.currentMonth == nil {
//            self.currentMonth = [Week].init(repeating: Week(), count: 4)
//        }
//
//        self.currentMonth![index] = self.currentWeek!
//    }
//
//    func delete(day: String, forWeek week: Week) {
//        self.update(week: week)
//        self.currentWeek![day] = nil
//    }
//
//    func delete(week: Week, atIndex index: Int) {
//        self.update(week: [:], atIndex: index)
//    }
//
//    func deleteMonth() {
//        self.currentMonth = [Week].init(repeating: Week(), count: 4)
//    }
//
//    func save(month: Month) {
//        self.update(month: month)
//        self.defaults.set(self.currentMonth, forKey: "currentMonth")
//    }
//
//    func save(week: Week, atIndex index: Int) {
//        self.update(week: week, atIndex: index)
//        self.save(month: self.currentMonth!)
//    }
//
//    func save(list: Checklist, forDay day: String, onWeek index: Int) {
//        if self.currentMonth == nil {
//            self.currentMonth = [Week].init(repeating: Week(), count: 4)
//            let newWeek = [day : list]
//            self.currentWeek = newWeek
//        }
//
//        self.currentWeek = self.currentMonth![index]
//        self.update(list: list, onDay: day, forWeek: self.currentWeek!)
//        self.save(week: self.currentWeek!, atIndex: index)
//        self.save(month: self.currentMonth!)
//    }
}
