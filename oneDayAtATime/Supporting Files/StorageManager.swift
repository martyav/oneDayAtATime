//
//  Defaults.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case pathNotFound
}

class DataStore {
    private init(){}
    static let manager = DataStore()
    static let pathName = "Days.plist"
    
    private var lists = [String: Checklist]() {
        didSet {
            do {
                try self.storeToDisk()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    func findDocumentsDirectory() -> URL {
        // returns path to app's sandbox
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths.first!
    }
    
    func find(filepath path: String) -> URL {
        return DataStore.manager.findDocumentsDirectory().appendingPathComponent(path)
    }
    
    func storeToDisk() throws {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(lists)
            try data.write(to: self.find(filepath: DataStore.pathName), options: .atomic)
        }
        catch {
            throw StorageError.pathNotFound
        }
    }
    
    private func save(list: Checklist, to day: String) {
        self.lists[day] = list
    }
    
    func add(item: String, to day: String) {
        let newItem = ListItem(title: item, checkedOff: false)
        var newList = self.lists[day] ?? Checklist()
        newList.append(newItem)
        
        self.save(list: newList, to: day)
    }
    
    func delete(itemAtIndex index: Int, from day: String) {
        guard let list = lists[day] else {
            return
        }
        
        guard index < list.count else {
            return
        }
        
        var newList = list
        
        newList.remove(at: index)
        
        self.save(list: newList, to: day)
    }
    
    func update(itemAtIndex index: Int, from day: String, withNewItem newItem: ListItem) {
        guard let list = lists[day] else {
            return
        }
        
        guard index < list.count else {
            return
        }
        
        var newList = list
        
        newList[index] = newItem
        
        self.save(list: newList, to: day)
    }
    
    func edit(itemAtIndex index: Int, from day: String, withNewValue newValue:
        String) {
        guard let list = lists[day] else {
            return
        }
        
        guard index < list.count else {
            return
        }
        
        var newList = list
        let currentCheckedOffStatus = list[index].checkedOff
        let newItem = ListItem(title: newValue, checkedOff: currentCheckedOffStatus)
        
        newList[index] = newItem
        
        self.save(list: newList, to: day)
    }
    
    func edit(itemAtIndex index: Int, from day: String, withNewValue newValue:
        Bool) {
        guard let list = lists[day] else {
            return
        }
        
        guard index < list.count else {
            return
        }
        
        var newList = list
        let currentTitle = list[index].title
        let newItem = ListItem(title: currentTitle, checkedOff: newValue)
        
        newList[index] = newItem
        
        self.save(list: newList, to: day)
    }
}
