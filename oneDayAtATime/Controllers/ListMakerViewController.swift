//
//  ListMakerViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class ListMakerViewController: UIViewController {
    var currentList: Checklist = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    var userTextInput: UITextField!
    var tableView: UITableView!
    var dayAndWeekControlView: DayAndWeekView!
    var manager: ListManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List Maker"
        
        do {
            self.currentList = try manager.retrieveList(forWeek: 0, onDay: CurrentTime.shared.dayOfWeek)
        }
        catch {
            print("No list yet")
        }
        
        self.implementGUI()
        self.setDelegatesAndDatasources()
        self.registerCells()
    }
    
    func setDelegatesAndDatasources() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.userTextInput.delegate = self
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
}

// MARK: - UITableViewDelegate and UITableViewDataSource

extension ListMakerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentList.isEmpty {
            return 1
        } else {
            return currentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        
        if currentList.isEmpty {
            return "Make A New List"
        } else {
            return "Add To A List" //return "Edit A Stored List"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let view = UIView(frame: frame)
        let button = UIButton(frame: frame)
        
        button.addTarget(self, action: #selector(self.didTapSave(sender:)), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        
        view.addSubview(button)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        
        if self.currentList.isEmpty {
            cell.titleLabel?.text = "I'm a new list. I'm empty!"
            cell.detailLabel?.text = "Type into the textbar to add your items."
        } else {
            cell.titleLabel?.text = self.currentList[indexPath.row].title
            cell.detailLabel?.text = self.currentList[indexPath.row].detail
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func didTapSave(sender: UIButton) {
        self.dayAndWeekControlView.removeFromSuperview()
        self.view.addSubview(self.dayAndWeekControlView)
        
        [
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            self.dayAndWeekControlView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 2),
            self.dayAndWeekControlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233),
            self.dayAndWeekControlView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ].forEach { $0.isActive = true }
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        animator.startAnimation()
    }
    
    @objc func didTapSegment() {
        guard self.dayAndWeekControlView.segmentedControlWeek.hasSelectedSegment && self.dayAndWeekControlView.segmentedControlDay.hasSelectedSegment else { return }
        
        let weekIndex = self.dayAndWeekControlView.segmentedControlWeek.selectedSegmentIndex
        let dayIndex = self.dayAndWeekControlView.segmentedControlDay.selectedSegmentIndex
        let dayOfWeek = WeekDayNames.short[dayIndex]
        
        self.manager.updateWeek(atIndex: weekIndex, forDay: dayOfWeek, withValue: self.currentList)
        let updatedWeek = try! self.manager.retrieve(week: weekIndex)
        self.manager.updateMonth(forWeek: weekIndex, withValue: updatedWeek)
        
        print("Week \(weekIndex), \(dayOfWeek)")
        
        do {
            try print(self.manager.retrieveList(forWeek: weekIndex, onDay: dayOfWeek))
            print(self.manager.returnStoredMonth())
            print(self.manager.returnCurrentMonth())
        }
        catch {
            print("Nice try")
        }
        
        self.dayAndWeekControlView.removeFromSuperview()
        self.view.addSubview(self.dayAndWeekControlView)
        
        [
            self.tableView.bottomAnchor.constraint(equalTo: self.dayAndWeekControlView.topAnchor),
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 2),
            self.dayAndWeekControlView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dayAndWeekControlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233)
        ].forEach { $0.isActive = true }
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        
        animator.startAnimation()
        
        let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thanks.", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ListMakerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let userTyped = self.userTextInput.text {
            let newItem = ListItem(title: userTyped, detail: "", checkedOff: false)
            currentList.append(newItem)
            self.userTextInput.text = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.userTextInput {
            self.userTextInput.resignFirstResponder()
        }
        
        return true
    }
}

// MARK: - UIViewCustomizing

extension ListMakerViewController: UIViewCustomizing {
    func createViews() {
        self.userTextInput = UITextField()
        self.tableView = UITableView()
        self.dayAndWeekControlView = DayAndWeekView()
        
        self.dayAndWeekControlView.segmentedControlDay.addTarget(self, action: #selector(self.didTapSegment), for: .valueChanged)
        self.dayAndWeekControlView.segmentedControlWeek.addTarget(self, action: #selector(self.didTapSegment), for: .valueChanged)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.userTextInput)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.dayAndWeekControlView)
    }
    
    func prepareForConstraints() {
        self.userTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.dayAndWeekControlView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        let standardWidth = self.view.widthAnchor
        let standardXPosition = self.view.centerXAnchor
        
        [
            self.userTextInput.widthAnchor.constraint(equalTo: standardWidth, multiplier: 0.8),
            self.userTextInput.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.userTextInput.centerXAnchor.constraint(equalTo: standardXPosition),
            self.userTextInput.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            
            self.tableView.widthAnchor.constraint(equalTo: standardWidth, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: standardXPosition),
            self.tableView.topAnchor.constraint(equalTo: self.userTextInput.bottomAnchor, constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.dayAndWeekControlView.topAnchor),
            
            self.dayAndWeekControlView.topAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.dayAndWeekControlView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dayAndWeekControlView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 100),
            self.dayAndWeekControlView.heightAnchor.constraint(equalToConstant: 233)
        ].forEach { $0.isActive = true }
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
        
        self.userTextInput.backgroundColor = .white
        self.userTextInput.borderStyle = .roundedRect
        self.userTextInput.tintColor = .black
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}
