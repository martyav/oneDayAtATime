//
//  StoredListCollectionViewCell.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/07/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class StoredListCollectionViewCell: UICollectionViewCell, CustomUIKitObject {
    var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
        setUpViewHeirarchy()
        prepareForConstraints()
        constrainViews()
        styleViews()
    }
    
    func createViews() {
        self.titleLabel = UILabel()
    }
    
    func setUpViewHeirarchy() {
        self.contentView.addSubview(titleLabel)
    }
    
    func prepareForConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.titleLabel.heightAnchor.constraint(equalToConstant: 40),
            self.titleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ]
    }
    
    func styleViews() {
        self.backgroundColor = .red
    }
}
