//
//  SelectListViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

/* WIP

 Initially, this was set up so users could switch weeks. However, on further thought, this functionality was placed inside today's vc. We could use this vc to allow user's to switch months, view how many lists they have completed...or just get rid of it entirely since it may just be redundant
*/

class ProfileViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
   // var defaults = UserDefaults.standard
    
//    var month: Month!
//    var selectedWeek: Week = [:] {
//        didSet {
//
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        month = defaults.object(forKey: "currentMonth") as? Month ?? []
//
//        if month.isEmpty {
//            print("no week selected")
//        } else {
//            selectedWeek = month[CurrentTime.shared.weekOfMonth() - 1]
//        }
        
        self.implementGUI()
        self.setDelegatesAndDataSources()
        self.registerCells()
    }
    
    func setDelegatesAndDataSources() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func registerCells() {
        self.collectionView.register(StoredListCollectionViewCell.self, forCellWithReuseIdentifier: StoredListCollectionViewCell.reuseIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifier.profileSectionHeader)
    }
    
    func implementGUI() {
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let frame = CGRect(x: 8, y: 0, width: 200, height: 40)
        var header: UICollectionReusableView = UICollectionReusableView(frame: frame)
        
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Identifier.profileSectionHeader, for: indexPath)
            
            if header.subviews.isEmpty {
                let label = UILabel(frame: frame)
                header.addSubview(label)
            }
            
            let titleLabel = header.subviews[0] as! UILabel
            titleLabel.text = "Week \(String(describing: indexPath.section + 1))"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoredListCollectionViewCell.reuseIdentifier, for: indexPath) as! StoredListCollectionViewCell
        
        cell.titleLabel.text = WeekDayNames.short[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let week = indexPath.section
        let dayOfTheWeek = WeekDayNames.short[indexPath.row]
       // let selectedList = month[week][dayOfTheWeek]
       // self.selectedWeek = month[indexPath.section - 1]
    }
}

extension ProfileViewController: UIViewCustomizing {
    func createViews() {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let cellSideLength = (self.view.frame.height/8) - 40 // cell heights must be less than the collection view's height minus any padding -- otherwise, the compiler freaks out and endlessly loops
        
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 5
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.estimatedItemSize = CGSize(width: cellSideLength, height: cellSideLength)
        collectionViewLayout.headerReferenceSize = CGSize(width: 200, height: 40)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.collectionView)
    }
    
    func prepareForConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        [
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].forEach { $0.isActive = true }
    }
    
    func styleViews() {        
        self.collectionView.backgroundColor = .white
    }
}
