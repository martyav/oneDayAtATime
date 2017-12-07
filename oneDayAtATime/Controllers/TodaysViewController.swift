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
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todaysChecklist = []
        
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: Constants.shared.listMakerCellIdentifier)
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

extension TodaysViewController: CustomUIKitObject {
    func createViews() {
        self.tableView = UITableView()
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.tableView)
    }
    
    func prepareForConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
}

