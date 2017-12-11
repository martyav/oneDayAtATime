//
//  StoredListCollectionViewCell.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 12/07/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class StoredListCollectionViewCell: UICollectionViewCell, UIViewCustomizing {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.titleLabel.font = UIFont(name: "Avenir", size: 20)
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.titleLabel.backgroundColor = .white
        self.titleLabel.contentMode = .center
        
        self.contentView.backgroundColor = .red
    }
}
