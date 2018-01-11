//
//  TodaysViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class TodaysViewController: UIViewController {
    var tableView: UITableView!
    var dayAndWeekControlView: DayAndWeekView!
    var list: Week!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Today's List"
        
        let todaysPath = self.findFileOfWeekToPresentInitially()
        DataStore.manager.select(filepath: todaysPath) // we need to check if the file exists and act accordingly. as-is, this defaults to initial value if the file does not exist

        
        self.list = DataStore.manager.retrieveFullWeek()
        
        self.implementGUI()
        self.registerCells()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        tableView.dataSource = self
        tableView.delegate = self
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
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        guard identifier == Identifier.todayVCToListMakerVC else {
//            return
//        }
//
//        // self.saveListState()
//
//        let listMakerInstance = ListMakerViewController()
//        navigationController?.pushViewController(listMakerInstance, animated: true)
//    }
    
    func findFileOfWeekToPresentInitially() -> PathName {
        let numOfWeeks = CurrentTime.shared.weeksInMonth
        let ordinalOfThisWeek = CurrentTime.shared.weekOfMonth
        
        if ordinalOfThisWeek == 1 {
            return .FirstWeek
        }
        
        if ordinalOfThisWeek == numOfWeeks {
            return .LastWeek
        }
        
        return .MiddleWeek
    }
    
    func updatecurrentList() {
        
    }
    
    func saveListState() {
        
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
       
    }
    
    @objc func didTapDaySegment(sender: UISegmentedControl) {
       
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
        let day = CurrentTime.shared.dayOfWeek
        let week = DataStore.manager.retrieveFullWeek()
        
        print(week[day]?.count ?? "nada")
        
        return week[day]?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "???"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        print("made cell")
        
        cell.titleLabel.text = list["Mon"]?[indexPath.row].title ?? "Your list is empty. Tap me to make a new one!"
        
        cell.accessoryType = .none
        
        if list["Mon"]?[indexPath.row].checkedOff != nil {
            cell.accessoryType = .checkmark
        }
        
        print(cell.titleLabel.text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped cell")
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell else {
            return
        }
        
        cell.accessoryType = checkOff(cell: cell, at: indexPath.row)
        
        if let item = self.list["Monday"]?[indexPath.row] {
            let newValue = checkOff(item: item)
            let updatedItem = ListItem(title: cell.titleLabel.text ?? "", checkedOff: newValue)
            
            self.list["Monday"]![indexPath.row] = updatedItem
        }
        
        print(self.list["Monday"]![indexPath.row])
    }
    
    func checkOff(cell: UITableViewCell, at index: Int) -> UITableViewCellAccessoryType {
        if cell.accessoryType == .none {
            return .checkmark
        }
        
        return .none
    }
    
    func checkOff(item: ListItem) -> Bool {
        return !item.checkedOff
    }
}

// MARK: - UIViewCustomizing

extension TodaysViewController: UIViewCustomizing {
    func createViews() {
        self.tableView = UITableView()
        self.dayAndWeekControlView = DayAndWeekView()
        
        self.dayAndWeekControlView.segmentedControlDay.selectedSegmentIndex = 1
        self.dayAndWeekControlView.segmentedControlWeek.selectedSegmentIndex = CurrentTime.shared.weekOfMonth
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
        
        self.tableView.backgroundColor = .white
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}
