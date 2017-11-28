//
//  ListMakerViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class ListMakerViewController: UITableViewController {

    var currentList: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.register(ListMakerTableViewCell.self, forCellReuseIdentifier: Constants.shared.listMakerCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.listMakerCellIdentifier, for: indexPath) as! ListMakerTableViewCell
        
        if let contents = currentList {
            cell.titleLabel?.text = contents[indexPath.row].title
            cell.detailLabel?.text = contents[indexPath.row].detail
        } else {
            cell.titleLabel?.text = "Your list is currently empty"
            cell.detailLabel?.text = "Click on the edit button to edit this list. Click on add to add another item."
        }
        
        return cell
    }
}
