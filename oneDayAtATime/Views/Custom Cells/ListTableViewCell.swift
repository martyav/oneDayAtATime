//
//  ListMakerTableViewCell.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/28/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell, ReuseIdentifying {
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createViews()
        setUpViewHeirarchy()
        prepareForConstraints()
        constrainViews()
        styleViews()
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.accessoryType = .none
    }
}

// MARK: - UIViewCustomizing

extension ListTableViewCell: UIViewCustomizing {
    func createViews() {
        self.titleLabel = UILabel()
    }
    
    func setUpViewHeirarchy() {
        self.contentView.addSubview(titleLabel)
    }
    
    func prepareForConstraints() {
        self.contentView.autoresizingMask = .flexibleHeight
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        [
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8.0),
            self.titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
    
    func styleViews() {
        self.titleLabel.font = UIFont(name: "Avenir", size: 20)
        
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail
        
        self.titleLabel.textColor = .black
        
        self.selectionStyle = .none
    }
}
