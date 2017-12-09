//
//  TodaysViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class TodaysViewController: UIViewController {
    
    var todaysChecklist: Checklist!
    var weeklyRoster: Week!
    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    var currentTime: CurrentTime!
    var todaysDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listItem1 = ListItem(title: "Hello", detail: "world", checkedOff: false)
        let listItem2 = ListItem(title: "It's Tuesday!", detail: "Hooray", checkedOff: false)
        let listItem3 = ListItem(title: "Cats are great", detail: "🐱", checkedOff: false)
        weeklyRoster = ["Mon": [listItem1], "Tue": [listItem2], "Wed": [listItem3, listItem3, listItem3]]
        
        currentTime = CurrentTime()
        todaysDate = currentTime.todaysDate
        let dayOfWeek = currentTime.dayOfWeek()
        
        todaysChecklist = weeklyRoster[dayOfWeek] ?? []
        
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: Constants.shared.listMakerCellIdentifier)
        self.collectionView.register(StoredListCollectionViewCell.self, forCellWithReuseIdentifier: Constants.shared.storedListCellIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "today")
    }
}

extension TodaysViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        
        return "Today's List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todaysChecklist.isEmpty {
            return 1
        } else {
            return todaysChecklist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.listMakerCellIdentifier, for: indexPath) as! ListTableViewCell
        
        if self.todaysChecklist.isEmpty {
            cell.titleLabel?.text = "I'm empty!"
            cell.detailLabel?.text = "Visit the Make A List screen to construct a new list."
        } else {
            cell.titleLabel?.text = self.todaysChecklist[indexPath.row].title
            cell.detailLabel?.text = self.todaysChecklist[indexPath.row].detail
        }
        
        return cell
    }
}

extension TodaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.storedListCellIdentifier, for: indexPath) as! StoredListCollectionViewCell
        
        cell.titleLabel.text = Constants.shared.weekDayNames[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dayOfTheWeek = Constants.shared.weekDayNames[indexPath.row]
        
        todaysChecklist = weeklyRoster[dayOfTheWeek] ?? []
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let frame = CGRect(x: 8, y: 0, width: 100, height: 40)
        var header: UICollectionReusableView = UICollectionReusableView(frame: frame)
        
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "today", for: indexPath)
            
            if header.subviews.isEmpty {
                let label = UILabel(frame: frame)
                label.clearsContextBeforeDrawing = false
                header.addSubview(label)
            }
            
            let titleLabel = header.subviews[0] as! UILabel
            titleLabel.text = "Schedules"
        }
        
        return header
    }
}

extension TodaysViewController: CustomUIKitObject {
    func createViews() {
        self.tableView = UITableView()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let cellSideLength = (self.view.frame.height/5) - 40 // cell heights must be less than the collection view's height minus any padding -- otherwise, the compiler freaks out and endlessly loops
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.estimatedItemSize = CGSize(width: cellSideLength, height: cellSideLength)
        layout.headerReferenceSize = CGSize(width: 1, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.collectionView)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor),
            
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.20),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.collectionView.backgroundColor = .white
    }
}
