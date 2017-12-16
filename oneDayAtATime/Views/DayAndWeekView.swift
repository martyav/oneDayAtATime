//
//  SaveAlertViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class DayAndWeekView: UIView, UIViewCustomizing {
    var contentView: UIView!
    var weekLabel: UILabel!
    var segmentedControlWeek: UISegmentedControl!
    var dayLabel: UILabel!
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
        self.contentView = UIView()
        self.weekLabel = UILabel()
        self.segmentedControlWeek = UISegmentedControl(items: ["Week 1", "Week 2", "Week 3", "Week 4"])
        self.dayLabel = UILabel()
        self.segmentedControlDay = UISegmentedControl(items: WeekDayNames.short)
    }
    
    func setUpViewHeirarchy() {
        self.addSubview(contentView)
        self.contentView.addSubview(self.weekLabel)
        self.contentView.addSubview(self.segmentedControlWeek)
        self.contentView.addSubview(self.dayLabel)
        self.contentView.addSubview(self.segmentedControlDay)
    }
    
    func prepareForConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.weekLabel.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlWeek.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControlDay.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.weekLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            self.weekLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.weekLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8),
            self.weekLabel.heightAnchor.constraint(equalToConstant: 44),
            
            self.segmentedControlWeek.topAnchor.constraint(equalTo: self.weekLabel.bottomAnchor, constant: 8),
            self.segmentedControlWeek.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.segmentedControlWeek.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.segmentedControlWeek.heightAnchor.constraint(equalToConstant: 44),
            
            self.dayLabel.topAnchor.constraint(equalTo: self.segmentedControlWeek.bottomAnchor, constant: 8),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 8),
            self.dayLabel.heightAnchor.constraint(equalToConstant: 44),
            
            self.segmentedControlDay.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 8),
            self.segmentedControlDay.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.segmentedControlDay.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.segmentedControlDay.heightAnchor.constraint(equalToConstant: 44)
            ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.weekLabel.text = "Choose week:"
        self.segmentedControlWeek.apportionsSegmentWidthsByContent = true
        self.segmentedControlWeek.isEnabled = true
        self.dayLabel.text = "Choose day of week:"
        self.segmentedControlDay.apportionsSegmentWidthsByContent = true
        self.segmentedControlDay.isEnabled = true
    }
}
