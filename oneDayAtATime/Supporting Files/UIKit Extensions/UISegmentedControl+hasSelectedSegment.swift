//
//  UISegmentedControl+isSelected.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/11/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    var hasSelectedSegment: Bool {
        return self.selectedSegmentIndex > -1
    }
}
