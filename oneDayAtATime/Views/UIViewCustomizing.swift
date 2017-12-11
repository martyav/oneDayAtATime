//
//  UIViewCustomizing.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/28/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import Foundation

protocol UIViewCustomizing {
    func createViews() -> Void
    func setUpViewHeirarchy() -> Void
    func prepareForConstraints() -> Void
    func constrainViews() -> Void
    func styleViews() -> Void
}
