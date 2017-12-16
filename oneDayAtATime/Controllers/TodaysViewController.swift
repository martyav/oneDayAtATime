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

    var dayOfWeek: String = CurrentTime.shared.dayOfWeek {
        didSet {
            self.updateTodaysChecklist()
        }
    }
    
    var weeklyRosterIndex: Int = 0 {
        didSet {
            self.updateTodaysChecklist()
        }
    }
    
    var month: Month!
    
    let manager = ListManager()
    
    var tableView: UITableView!
    var segmentedControlWeek: UISegmentedControl!
    var segmentedControlDay: UISegmentedControl!
    
    var todaysDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Today's List"
        
        self.todaysDate = CurrentTime.shared.todaysDate
        
        self.implementGUI()
        self.setDelegatesAndDatasources()
        self.registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.month = self.manager.returnCurrentMonth()
        self.weeklyRosterIndex = self.segmentedControlWeek.selectedSegmentIndex
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
        
        //self.saveListState()
        
        let listMakerInstance = ListMakerViewController()
        listMakerInstance.manager = self.manager
        navigationController?.pushViewController(listMakerInstance, animated: true)
    }
    
    func updateTodaysChecklist() {
        self.todaysChecklist = self.month[self.weeklyRosterIndex][self.dayOfWeek] ?? []
    }
    
    /*func saveListState() {
        self.manager.updateWeek(atIndex: self.weeklyRosterIndex, forDay: self.dayOfWeek, withValue: self.todaysChecklist)
        let updatedWeek = try! self.manager.retrieve(week: weeklyRosterIndex)
        self.manager.updateMonth(forWeek: weeklyRosterIndex, withValue: updatedWeek)
        
        print("Week \(self.weeklyRosterIndex), \(self.dayOfWeek)")
        
        do {
            try print(self.manager.retrieveList(forWeek: self.weeklyRosterIndex, onDay: self.dayOfWeek))
            print(self.manager.returnStoredMonth())
            print(self.manager.returnCurrentMonth())
        }
        catch {
            print("Nice try")
        }
    }*/
    
    @objc func didTapWeekSegment(sender: UISegmentedControl) {
        print("tapped")
        self.weeklyRosterIndex = sender.selectedSegmentIndex
    }
    
    @objc func didTapDaySegment(sender: UISegmentedControl) {
        print("tipped")
        self.dayOfWeek = WeekDayNames.short[sender.selectedSegmentIndex]
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
                self.month[self.weeklyRosterIndex][self.dayOfWeek]![indexPath.row].checkedOff = !self.month[self.weeklyRosterIndex][self.dayOfWeek]![indexPath.row].checkedOff
               // self.weeklyRosterIndex = self.segmentedControlWeek.selectedSegmentIndex
                // self.todaysChecklist = self.weeklyRoster[self.dayOfWeek]!
                print( self.month[self.segmentedControlWeek.selectedSegmentIndex][self.dayOfWeek]![indexPath.row].checkedOff)
                self.checkOff(cell: cell, at: indexPath.row)
                print(self.todaysChecklist[indexPath.row].checkedOff)
            }
        }
    }
    
    func checkOff(cell: UITableViewCell, at index: Int) {
        if self.month[self.weeklyRosterIndex][self.dayOfWeek]![index].checkedOff {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

// MARK: - UIViewCustomizing

extension TodaysViewController: UIViewCustomizing {
    func createViews() {
        self.tableView = UITableView()
        
        self.segmentedControlWeek = UISegmentedControl(items: ["Week 1", "Week 2", "Week 3", "Week 4"])
        self.segmentedControlWeek.addTarget(self, action: #selector(self.didTapWeekSegment(sender:)), for: .valueChanged)
        self.segmentedControlWeek.selectedSegmentIndex = CurrentTime.shared.weekOfMonth()
        
        self.segmentedControlDay = UISegmentedControl(items: WeekDayNames.short)
        self.segmentedControlDay.addTarget(self, action: #selector(self.didTapDaySegment(sender:)), for: .valueChanged)
        self.segmentedControlDay.selectedSegmentIndex = WeekDayNames.short.index(of: self.dayOfWeek)!
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.segmentedControlWeek)
        self.view.addSubview(self.segmentedControlDay)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlWeek.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlDay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        let standardWidth = self.view.widthAnchor
        let standardXPosition = self.view.centerXAnchor
        
        [
            self.tableView.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.segmentedControlDay.topAnchor),
            
            self.segmentedControlDay.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.segmentedControlDay.centerXAnchor.constraint(equalTo: standardXPosition),
            self.segmentedControlDay.heightAnchor.constraint(equalToConstant: 44),
            self.segmentedControlDay.bottomAnchor.constraint(equalTo: self.segmentedControlWeek.topAnchor, constant: -8),
            
            self.segmentedControlWeek.widthAnchor.constraint(equalTo: standardWidth),
            self.segmentedControlWeek.centerXAnchor.constraint(equalTo: standardXPosition),
            self.segmentedControlWeek.heightAnchor.constraint(equalToConstant: 44),
            self.segmentedControlWeek.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].forEach { $0.isActive = true }
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
        
        self.tableView.backgroundColor = .clear
        // self.tableView.separatorStyle = .none
        
        self.segmentedControlWeek.backgroundColor = .white
        self.segmentedControlWeek.apportionsSegmentWidthsByContent = true
        
        self.segmentedControlDay.backgroundColor = .white
        self.segmentedControlDay.apportionsSegmentWidthsByContent = true
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}
