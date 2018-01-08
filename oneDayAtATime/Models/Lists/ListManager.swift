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
    private var storage = StorageManager.defaults
    private var month: Month {
        didSet {
            self.storage.save(value: self.month)
        }
    }
    
    init(month: Month) {
        self.month = month
    }
    
    init() {
        self.month = self.storage.retrieve()
    }
    
    private func isIndexValid(_ week: Int) -> Bool {
        return self.month.count >= week && week > -1
    }
    
//    func save() {
//        self.storage.save(value: self.month)
//    }
    
    func returnCurrentMonth() -> Month {
        return self.month
    }
    
    func returnStoredMonth() -> Month {
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
            
            if month[index][day] != nil {
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


