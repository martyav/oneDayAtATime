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
           //self.saveListState()
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
    var dayAndWeekControlView: DayAndWeekView!
    
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
        self.weeklyRosterIndex = self.dayAndWeekControlView.segmentedControlWeek.selectedSegmentIndex
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dayAndWeekControlView.removeFromSuperview()
        self.view.addSubview(self.dayAndWeekControlView)
        
        [
            self.dayAndWeekControlView.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233),
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
        ].forEach { $0.isActive = true }
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
        
        // self.saveListState()
        
        let listMakerInstance = ListMakerViewController()
        listMakerInstance.manager = self.manager
        navigationController?.pushViewController(listMakerInstance, animated: true)
    }
    
    func updateTodaysChecklist() {
        print("\(self.weeklyRosterIndex) \(self.dayOfWeek) \(self.month.count)")
        self.todaysChecklist = self.month[self.weeklyRosterIndex][self.dayOfWeek] ?? []
    }
    
    func saveListState() {
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
    }
    
    @objc func didTapPullOut(sender: UIButton) {
        print("pullout tapped")
        
        self.dayAndWeekControlView.removeFromSuperview()
        self.view.addSubview(self.dayAndWeekControlView)
        
        [
            self.tableView.bottomAnchor.constraint(equalTo: self.dayAndWeekControlView.topAnchor),
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            self.dayAndWeekControlView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 2),
            self.dayAndWeekControlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233)
        ].forEach { $0.isActive = true }
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        animator.startAnimation()
    }
    
    @objc func didTapWeekSegment(sender: UISegmentedControl) {
        print("week segment tapped")
        self.weeklyRosterIndex = sender.selectedSegmentIndex
    }
    
    @objc func didTapDaySegment(sender: UISegmentedControl) {
        print("day segment tapped")
        print(sender.selectedSegmentIndex)
        self.dayOfWeek = WeekDayNames.short[sender.selectedSegmentIndex]
    }
    
    @objc func swipeRightOnControls(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            guard sender.direction == .right else { return }
        
            self.dayAndWeekControlView.removeFromSuperview()
            self.view.addSubview(self.dayAndWeekControlView)
        
            [
                self.dayAndWeekControlView.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
                self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233),
                self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
            ].forEach { $0.isActive = true }
        }
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
        print("tapped cell")
        if self.todaysChecklist.isEmpty {
            performSegue(withIdentifier: Identifier.todayVCToListMakerVC, sender: self)
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                self.todaysChecklist[indexPath.row].checkedOff = !self.todaysChecklist[indexPath.row].checkedOff
                print("Checked off == \(self.todaysChecklist[indexPath.row].checkedOff)")
                self.checkOff(cell: cell, at: indexPath.row)
                print("Value listed in datasource == \(self.todaysChecklist[indexPath.row].checkedOff)")
            }
        }
    }
    
    func checkOff(cell: UITableViewCell, at index: Int) {
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
        } else if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        }
    }
}

// MARK: - UIViewCustomizing

extension TodaysViewController: UIViewCustomizing {
    func createViews() {
        self.tableView = UITableView()
        self.dayAndWeekControlView = DayAndWeekView()
        
        self.dayAndWeekControlView.segmentedControlDay.selectedSegmentIndex = WeekDayNames.short.index(of: self.dayOfWeek)!
        self.dayAndWeekControlView.segmentedControlWeek.selectedSegmentIndex = CurrentTime.shared.weekOfMonth()
        self.dayAndWeekControlView.segmentedControlDay.addTarget(self, action: #selector(self.didTapDaySegment(sender:)), for: .valueChanged)
        self.dayAndWeekControlView.segmentedControlWeek.addTarget(self, action: #selector(self.didTapWeekSegment(sender:)), for: .valueChanged)
        self.dayAndWeekControlView.pullOutButton.addTarget(self, action: #selector(self.didTapPullOut(sender:)), for: UIControlEvents.touchUpInside)
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightOnControls(sender:)))
//        swipeRight.direction = .right
//        self.dayAndWeekControlView.contentView.addGestureRecognizer(swipeRight)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.dayAndWeekControlView)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.dayAndWeekControlView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        let standardWidth = self.view.widthAnchor
        let standardXPosition = self.view.centerXAnchor
        
        [
            self.tableView.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.dayAndWeekControlView.topAnchor),
            
            self.dayAndWeekControlView.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233),
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
        ].forEach { $0.isActive = true }
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
        
        self.tableView.backgroundColor = .clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}
