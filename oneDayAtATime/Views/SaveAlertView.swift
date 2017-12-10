//
//  SaveAlertViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class SaveAlertView: UIView, CustomUIKitObject {
    //var confirmButton: UIButton!
    var contentView: UIView!
    var segmentedControlWeek: UISegmentedControl!
    var segmentedControlDay: UISegmentedControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.implementGUI()
    }
    
    func implementGUI() {
        self.createViews()
        self.setUpViewHeirarchy()
        self.prepareForConstraints()
        self.constrainViews()
        self.styleViews()
    }
    
     func createViews() {
        //self.confirmButton = UIButton()
        self.contentView = UIView()
        self.segmentedControlWeek = UISegmentedControl(items: ["Wk 1", "Wk 2", "Wk 3", "Wk 4"])
        self.segmentedControlDay = UISegmentedControl(items: ["S", "M", "T", "W", "T", "F", "S"])
    }
    
     func setUpViewHeirarchy() {
        //self.addSubview(self.confirmButton)
        self.addSubview(contentView)
        self.contentView.addSubview(self.segmentedControlWeek)
        self.contentView.addSubview(self.segmentedControlDay)
    }
    
    func prepareForConstraints() {
       // self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlWeek.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlDay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.segmentedControlWeek.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.segmentedControlWeek.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.segmentedControlWeek.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.segmentedControlWeek.heightAnchor.constraint(equalToConstant: 44),

            self.segmentedControlDay.topAnchor.constraint(equalTo: self.segmentedControlWeek.bottomAnchor, constant: 8),
            self.segmentedControlDay.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.segmentedControlDay.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.segmentedControlDay.heightAnchor.constraint(equalToConstant: 44)
            
//            self.confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            self.confirmButton.widthAnchor.constraint(equalTo: self.widthAnchor),
//            self.confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            self.confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.segmentedControlWeek.apportionsSegmentWidthsByContent = true
        self.segmentedControlDay.apportionsSegmentWidthsByContent = true
        //self.confirmButton.setTitle("Confirm", for: .normal)
    }
}


