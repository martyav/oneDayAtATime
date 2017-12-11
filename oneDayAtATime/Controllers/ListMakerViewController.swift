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
   // var manager: ListManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List Maker"
                
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
         self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: Identifier.listMakerCell)
    }
    
    func implementGUI() {
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
    }
}

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
        
        return "Make A New List"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.listMakerCell, for: indexPath) as! ListTableViewCell
        
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
        let magicNumber = CGFloat(18.0) // need to get a relative value to prevent controls from exceeding margin...
        let alert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let frame = CGRect(x: 0, y: 8, width: alert.view.bounds.size.width - magicNumber, height: 200)
        alert.view.addSubview(SaveAlertView(frame: frame))
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alert.addAction(confirmButton)
        self.present(alert, animated: true, completion: nil)
        
       // self.manager.save(list: self.currentList, forDay: "Sun", onWeek: 0)
        
//        print(self.manager.checkWeek())
//        print(self.manager.checkMonth())
        
//        if defaults.array(forKey: "currentMonth") == nil {
//            defaults.set(["Sun": self.currentList], forKey: "currentMonth")
//        }
    }
}

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

extension ListMakerViewController: UIViewCustomizing {
    func createViews() {
        self.userTextInput = UITextField()
        self.tableView = UITableView()
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.userTextInput)
        self.view.addSubview(self.tableView)
    }
    
    func prepareForConstraints() {
        self.userTextInput.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.userTextInput.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.userTextInput.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.userTextInput.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.userTextInput.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -16),
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.userTextInput.bottomAnchor, constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ].map { $0.isActive = true }
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
