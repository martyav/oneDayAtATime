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

enum PathName: String {
    case Week1, Week2, Week3
}

final class DataStore {
    static let manager = DataStore()
    var pathName: String = "Week1.plist"
    
    private init(){}
    
    private var lists = [String: Checklist]() {
        didSet {
            self.storeToDisk()
        }
    }
    
    func select(filepath path: PathName) {
        self.pathName = "\(path.rawValue).plist"
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
    
    func storeToDisk() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(lists)
            try data.write(to: self.find(filepath: pathName), options: .atomic)
        }
        catch {
            print(StorageError.pathNotFound.localizedDescription)
        }
    }
    
    func save(list: Checklist, to day: String) {
        self.lists[day] = list
    }
    
    func retrieve(list day: String) -> Checklist? {
        return self.lists[day]
    }
    
    func retrieveWeek() -> [String: Checklist] {
        return lists
    }
    
    func retrieveWeek(_ num: Int) -> [String: Checklist] {
        let currentPathName = self.pathName.components(separatedBy: ".").first!
        var tempPathName: PathName
        
        switch num {
        case 3:
            tempPathName = .Week3
        case 2:
            tempPathName = .Week2
        default:
            tempPathName = .Week1
        }
        
        defer {
            select(filepath: PathName(rawValue: currentPathName)!)
        }
        
        select(filepath: tempPathName)
        return retrieveWeek()
    }
    
    func add(item: String, to day: String) {
        let newItem = ListItem(title: item, checkedOff: false)
        var newList = retrieve(list: day) ?? Checklist()
        
        newList.append(newItem)
        
        self.save(list: newList, to: day)
    }
    
    func delete(itemAtIndex index: Int, from day: String) {
        guard let list = retrieve(list: day) else {
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
        guard let list = retrieve(list: day) else {
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
        guard let list = retrieve(list: day) else {
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
        guard let list = retrieve(list: day) else {
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
    
    func load() {
        let path = find(filepath: pathName)
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data.init(contentsOf: path)
            self.lists = try decoder.decode([String: Checklist].self, from: data)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
