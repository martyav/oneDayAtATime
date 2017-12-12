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
    private var month: Month
    private var storage = StorageManager.defaults
    
    init(month: Month) {
        self.month = month
    }
    
    init() {
        self.month = self.storage.retrieve()
    }
    
    private func isIndexValid(_ week: Int) -> Bool {
        return self.month.count >= week && week > -1
    }
    
    func save() {
        self.storage.save(value: self.month)
    }
    
    func displayCurrentMonth() -> Month {
        return self.month
    }
    
    func displayStoredMonth() -> Month {
        return self.storage.retrieve()
    }
    
    func retrieveList(forWeek week: Int, onDay day: String) throws -> Checklist {
        guard !month.isEmpty else {
            throw ScheduleError.monthHasNoValidWeeks
        }
        
        guard isIndexValid(week) else {
            throw ScheduleError.weekDoesNotExist
        }
        
        guard !month[week].isEmpty else {
            throw ScheduleError.weekHasNoValidDays
        }
        
        guard let foundList = month[week][day] else {
            throw ScheduleError.dayHasNoValidList
        }
        
        return foundList
    }
    
    func retrieve(week: Int) throws -> Week {
        guard !month.isEmpty else {
            throw ScheduleError.monthHasNoValidWeeks
        }
        
        guard isIndexValid(week) else {
            throw ScheduleError.weekDoesNotExist
        }
        
        return month[week]
    }
    
    func add(week: Week) throws {
        guard month.count <= 4 else {
            throw ScheduleError.monthIsFull
        }
        
        month.append(week)
    }
    
    func updateMonth(forWeek index: Int, withValue value: Week) {
        guard isIndexValid(index) || !month.isEmpty else {
            month.insert(value, at: index)
            return
        }
        
        month[index] = value
    }
    
    func updateWeek(atIndex index: Int, forDay day: String, withValue value: Checklist) {
        do {
            _ = try retrieve(week: index)
            
            if let dayExists = month[index][day] {
                print("exists already.")
                month[index][day] = value
            } else {
                print("does not exist already.")
                month[index][day] = value
            }
        }
            
        catch {
            updateMonth(forWeek: index, withValue: Week())
            updateWeek(atIndex: index, forDay: day, withValue: value)
        }
    }
    
    func deleteList(forWeek week: Int, onDay day: String) {
        guard isIndexValid(week) else {
            return
        }
        
        month[week][day] = nil
    }
}

//class ListManager {
//    let defaults: UserDefaults = UserDefaults.standard
//    let todaysDate: Date = CurrentTime.shared.todaysDate
//    private var currentDayOfWeek: String = CurrentTime.shared.dayOfWeek()
//    private var currentWeek: Week
//    private var currentWeekIndex: Int = CurrentTime.shared.weekOfMonth()
//    private var currentMonth: Month
//
//    init() {
//        self.currentMonth = self.defaults.array(forKey: "currentMonth") as? Month ?? [Week].init(repeating: Week(), count: 4)
//        self.currentWeek = self.currentMonth[self.currentWeekIndex]
//    }
//
//    func checkDay() -> String {
//        return self.currentDayOfWeek
//    }
//
//    func checkWeek() -> Week? {
//        return self.currentWeek
//    }
//
//    func checkMonth() -> Month? {
//        return self.currentMonth
//    }

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
//}

