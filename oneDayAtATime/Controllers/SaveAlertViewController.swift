//
//  SaveAlertViewController.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class SaveAlertViewController: UIAlertController { // we can't subclass from UIAlertController tho -- follow https://github.com/JSSAlertView/JSSAlertView/blob/master/JSSAlertView/Classes/JSSAlertView.swift for a roadmap of how to handle this
    var alertControls: SaveAlertGUI!
    var confirmButton: UIAlertAction!
    var manager: ListManager!
    var list: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let magicNumber = CGFloat(18.0) // need to get a relative value to prevent controls from exceeding margin...
        let frame = CGRect(x: 0, y: 8, width: self.view.bounds.size.width - magicNumber, height: 200)
        
        self.alertControls = SaveAlertGUI(frame: frame)
        self.view.addSubview(alertControls)
        
        self.confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: {(alert: UIAlertAction) in
            
            let weekIndex = self.alertControls.segmentedControlWeek.selectedSegmentIndex
            let dayIndex = self.alertControls.segmentedControlDay.selectedSegmentIndex
            let dayOfWeek = WeekDayNames.short[dayIndex]

            self.manager.updateWeek(atIndex: weekIndex, forDay: dayOfWeek, withValue: self.list)
            let updatedWeek = try! self.manager.retrieve(week: weekIndex)
            self.manager.updateMonth(forWeek: weekIndex, withValue: updatedWeek)

            print("Week \(weekIndex), \(dayOfWeek)")
            self.manager.save()
            do {
                try print(self.manager.retrieveList(forWeek: weekIndex, onDay: dayOfWeek))
                print(self.manager.returnStoredMonth())
                print(self.manager.returnCurrentMonth())
            }
            catch {
                print("Nice try")
            }
        })
        
        confirmButton.isEnabled = false
        self.addAction(confirmButton)
        self.alertControls.segmentedControlDay.addTarget(self, action: #selector(didTapDaySegment(sender:)), for: .valueChanged)
        self.alertControls.segmentedControlWeek.addTarget(self, action: #selector(didTapWeekSegment(sender:)), for: .valueChanged)
    }
    
    func enableOrDisableConfirmButton() {
        guard self.alertControls.segmentedControlWeek.hasSelectedSegment && self.alertControls.segmentedControlDay.hasSelectedSegment else {
            self.confirmButton.isEnabled = false
            return
        }
        
        self.confirmButton.isEnabled = true
    }
    
    @objc func didTapWeekSegment(sender: UISegmentedControl) {
        // save selected segment
        print(sender.selectedSegmentIndex)
        
        self.enableOrDisableConfirmButton()
    }
    
    @objc func didTapDaySegment(sender: UISegmentedControl) {
        // save selected segment
        print(sender.selectedSegmentIndex)
        
        self.enableOrDisableConfirmButton()
    }
}
