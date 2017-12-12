//
//  TodaysViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class TodaysViewController: UIViewController {
    var todaysChecklist: Checklist = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    var weeklyRoster: Week = [:] {
        didSet {
            self.todaysChecklist = self.weeklyRoster[self.dayOfWeek] ?? []
            self.collectionView?.reloadData()
        }
    }
    
    var dayOfWeek: String = CurrentTime.shared.dayOfWeek {
        didSet {
            self.todaysChecklist = self.weeklyRoster[self.dayOfWeek] ?? []
        }
    }
    
//    let manager = ListManager()
    
    var tableView: UITableView!
    var segmentedControl: UISegmentedControl!
    var collectionView: UICollectionView!
    
    var todaysDate: Date!
    var month: Month!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Today's List"
        
        self.todaysDate = CurrentTime.shared.todaysDate
        
        self.implementGUI()
        self.setDelegatesAndDatasources()
        self.registerCells()
        
        let listItem1 = ListItem(title: "Hello", detail: "world", checkedOff: false)
        let listItem2 = ListItem(title: "It's Tuesday!", detail: "Hooray", checkedOff: false)
        let listItem3 = ListItem(title: "Cats are great", detail: "🐱", checkedOff: false)
        let newWeek = ["Mon": [listItem1], "Tue": [listItem2], "Wed": [listItem3, listItem3, listItem3]]
        
        self.month = [newWeek, Week(), Week(), ["Mon": [listItem3]]]
        self.weeklyRoster = self.month[self.segmentedControl.selectedSegmentIndex]
        
//        if let savedMonth = self.manager.checkMonth() {
//            self.month = savedMonth
//        } else {
//            self.month = [Week].init(repeating: Week(), count: 4)
//            self.manager.update(month: self.month)
//            self.manager.save(month: self.manager.checkMonth()!)
//        }
        
//        if let savedWeek =  self.manager.checkWeek() {
//            self.weeklyRoster = savedWeek
//        }
    }
    
    func setDelegatesAndDatasources() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func registerCells() {
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: Identifier.listMakerCell)
        self.collectionView.register(StoredListCollectionViewCell.self, forCellWithReuseIdentifier: Identifier.storedListCell)
    }
    
    func implementGUI() {
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        guard identifier == Identifier.todayVCToListMakerVC else {
            return
        }
        
        let listMakerInstance = ListMakerViewController()
        // listMakerInstance.manager = self.manager
        navigationController?.pushViewController(listMakerInstance, animated: true)
    }
    
    @objc func didTapWeekSegment(sender: UISegmentedControl) {
        print("tapped")
        self.weeklyRoster = self.month[sender.selectedSegmentIndex]
        print(sender.selectedSegmentIndex)
        dump(weeklyRoster)
    }
}

extension TodaysViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todaysChecklist.isEmpty {
            return 1
        } else {
            return todaysChecklist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.listMakerCell, for: indexPath) as! ListTableViewCell
        
        if self.todaysChecklist.isEmpty {
            cell.titleLabel?.text = "I'm empty!"
            cell.detailLabel?.text = "Tap me to construct a new list."
        } else {
            cell.titleLabel?.text = self.todaysChecklist[indexPath.row].title
            cell.detailLabel?.text = self.todaysChecklist[indexPath.row].detail
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.todaysChecklist.isEmpty {
            performSegue(withIdentifier: Identifier.todayVCToListMakerVC, sender: self)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.storedListCell, for: indexPath) as! StoredListCollectionViewCell
        
        cell.titleLabel.text = WeekDayNames.short[indexPath.row]
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            cell.contentView.backgroundColor = .red
        case 1:
            cell.contentView.backgroundColor = .purple
        case 2:
            cell.contentView.backgroundColor = .blue
        case 3:
            cell.contentView.backgroundColor = .black
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dayOfWeek = WeekDayNames.short[indexPath.row]
        
        todaysChecklist = weeklyRoster[dayOfWeek] ?? []
    }
}

extension TodaysViewController: UIViewCustomizing {
    func createViews() {
        self.tableView = UITableView()
        self.segmentedControl = UISegmentedControl(items: ["Week 1", "Week 2", "Week 3", "Week 4"])
        self.segmentedControl.addTarget(self, action: #selector(self.didTapWeekSegment(sender:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = CurrentTime.shared.weekOfMonth()
        
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let cellSideLength = (self.view.frame.height/5) - 40 // cell heights must be less than the collection view's height minus any padding -- otherwise, the compiler freaks out and endlessly loops
        
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 20
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.estimatedItemSize = CGSize(width: cellSideLength, height: cellSideLength)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.collectionView)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        let standardWidth = self.view.widthAnchor
        let standardXPosition = self.view.centerXAnchor
        
        _ = [
            self.tableView.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.segmentedControl.topAnchor),
            
            self.segmentedControl.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.segmentedControl.centerXAnchor.constraint(equalTo: standardXPosition),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            self.segmentedControl.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: -4),
            
            self.collectionView.widthAnchor.constraint(equalTo: standardWidth),
            self.collectionView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.20),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.segmentedControl.backgroundColor = .white
        self.segmentedControl.apportionsSegmentWidthsByContent = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.collectionView.backgroundColor = .white
    }
}
