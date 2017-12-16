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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var weeklyRoster: Week = [:] {
        didSet {
            self.todaysChecklist = self.weeklyRoster[self.dayOfWeek] ?? []
        }
    }
    
    var dayOfWeek: String = CurrentTime.shared.dayOfWeek
    
    let manager = ListManager()
    
    var tableView: UITableView!
    var segmentedWeekControl: UISegmentedControl!
    var segmentedDayControl: UISegmentedControl!
    
    var todaysDate: Date!
    var month: Month!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Today's List"
        
        self.todaysDate = CurrentTime.shared.todaysDate
        
        self.implementGUI()
        self.setDelegatesAndDatasources()
        self.registerCells()
        
        self.month = self.manager.returnCurrentMonth()
        self.weeklyRoster = self.month[self.segmentedWeekControl.selectedSegmentIndex]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.month = self.manager.returnCurrentMonth()
        self.weeklyRoster = self.month[self.segmentedWeekControl.selectedSegmentIndex]
    }
    
    func setDelegatesAndDatasources() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func registerCells() {
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
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
        listMakerInstance.manager = self.manager
        navigationController?.pushViewController(listMakerInstance, animated: true)
    }
    
    @objc func didTapWeekSegment(sender: UISegmentedControl) {
        print("tapped")
       // self.weeklyRoster = self.month[sender.selectedSegmentIndex]
        self.todaysChecklist = self.month[sender.selectedSegmentIndex][self.dayOfWeek] ?? []
    }
    
    @objc func didTapDaySegment(sender: UISegmentedControl) {
        print("tipped")
        self.dayOfWeek = WeekDayNames.short[sender.selectedSegmentIndex]
        self.todaysChecklist = self.month[self.segmentedWeekControl.selectedSegmentIndex][self.dayOfWeek] ?? []
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = WeekDayNames.short.index(of: self.dayOfWeek)!
        return WeekDayNames.long[index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        print("made cell")
        
        if self.todaysChecklist.isEmpty {
            print("empty")
            cell.titleLabel?.text = "I'm empty!"
            cell.detailLabel?.text = "Tap me to construct a new list."
            print("We've updated the cell")
        } else {
            print("full")
            cell.titleLabel?.text = self.todaysChecklist[indexPath.row].title
            cell.detailLabel?.text = self.todaysChecklist[indexPath.row].detail
            print("We've updated the cell")
            
            self.checkOff(cell: cell, at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
        if self.todaysChecklist.isEmpty {
            performSegue(withIdentifier: Identifier.todayVCToListMakerVC, sender: self)
        } else {
            if let cell = tableView.cellForRow(at: indexPath) {
                self.month[self.segmentedWeekControl.selectedSegmentIndex][self.dayOfWeek]![indexPath.row].checkedOff = !self.month[self.segmentedWeekControl.selectedSegmentIndex][self.dayOfWeek]![indexPath.row].checkedOff
                self.weeklyRoster = self.month[self.segmentedWeekControl.selectedSegmentIndex]
                // self.todaysChecklist = self.weeklyRoster[self.dayOfWeek]!
                print( self.weeklyRoster[self.dayOfWeek]![indexPath.row].checkedOff)
                self.checkOff(cell: cell, at: indexPath.row)
                print(self.todaysChecklist[indexPath.row].checkedOff)
            }
        }
    }
    
    func checkOff(cell: UITableViewCell, at index: Int) {
        if self.month[self.segmentedWeekControl.selectedSegmentIndex][self.dayOfWeek]![index].checkedOff {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

/*extension TodaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoredListCollectionViewCell.reuseIdentifier, for: indexPath) as! StoredListCollectionViewCell
        
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
        self.todaysChecklist = self.month[self.segmentedControl.selectedSegmentIndex][self.dayOfWeek] ?? []
    }
}*/

// MARK: - UIViewCustomizing

extension TodaysViewController: UIViewCustomizing {
    func createViews() {
        self.tableView = UITableView()
        
        self.segmentedWeekControl = UISegmentedControl(items: ["Week 1", "Week 2", "Week 3", "Week 4"])
        self.segmentedWeekControl.addTarget(self, action: #selector(self.didTapWeekSegment(sender:)), for: .valueChanged)
        self.segmentedWeekControl.selectedSegmentIndex = CurrentTime.shared.weekOfMonth()
        
        self.segmentedDayControl = UISegmentedControl(items: WeekDayNames.short)
        self.segmentedDayControl.addTarget(self, action: #selector(self.didTapDaySegment(sender:)), for: .valueChanged)
        self.segmentedDayControl.selectedSegmentIndex = WeekDayNames.short.index(of: self.dayOfWeek)!
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.segmentedWeekControl)
        self.view.addSubview(self.segmentedDayControl)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedWeekControl.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedDayControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        let standardWidth = self.view.widthAnchor
        let standardXPosition = self.view.centerXAnchor
        
        [
            self.tableView.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.segmentedDayControl.topAnchor),
            
            self.segmentedDayControl.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.segmentedDayControl.centerXAnchor.constraint(equalTo: standardXPosition),
            self.segmentedDayControl.heightAnchor.constraint(equalToConstant: 44),
            self.segmentedDayControl.bottomAnchor.constraint(equalTo: self.segmentedWeekControl.topAnchor, constant: -8),
            
            self.segmentedWeekControl.widthAnchor.constraint(equalTo: standardWidth),
            self.segmentedWeekControl.centerXAnchor.constraint(equalTo: standardXPosition),
            self.segmentedWeekControl.heightAnchor.constraint(equalToConstant: 44),
            self.segmentedWeekControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].forEach { $0.isActive = true }
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
        
        self.tableView.backgroundColor = .clear
        // self.tableView.separatorStyle = .none
        
        self.segmentedWeekControl.backgroundColor = .white
        self.segmentedWeekControl.apportionsSegmentWidthsByContent = true
        
        self.segmentedDayControl.backgroundColor = .white
        self.segmentedDayControl.apportionsSegmentWidthsByContent = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}
