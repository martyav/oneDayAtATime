//
//  SelectListViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/27/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var month: Month!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        month = Month()
        
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(StoredListCollectionViewCell.self, forCellWithReuseIdentifier: Constants.shared.storedListCellIdentifier)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.shared.profileSectionHeader)
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
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.shared.profileSectionHeader, for: indexPath)
            
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.storedListCellIdentifier, for: indexPath) as! StoredListCollectionViewCell
        
        cell.titleLabel.text = Constants.shared.weekDayNames[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let week = indexPath.section
        let dayOfTheWeek = Constants.shared.weekDayNames[indexPath.row]
        let selectedList = month[week][dayOfTheWeek]
        // segue back to today vc and make this list today's list
    }
}

extension ProfileViewController: CustomUIKitObject {
    func createViews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = CGSize(width: 50, height: 50)
        layout.headerReferenceSize = CGSize(width: 200, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    func setUpViewHeirarchy() {
        self.view.addSubview(self.collectionView)
    }
    
    func prepareForConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor) // figure out where tabbar begins and attach bottom of collection view to that y coordinate
            ].map { $0.isActive = true }
    }
    
    func styleViews() {        
        self.collectionView.backgroundColor = .white
    }
}
