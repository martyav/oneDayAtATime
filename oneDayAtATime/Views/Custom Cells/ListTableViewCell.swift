//
//  ListMakerTableViewCell.swift
//  oneDayAtATime
//
//  Created by Marty Hernandez Avedon on 11/28/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell, CustomUIKitObject {
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createViews() {
        self.titleLabel = UILabel()
        self.detailLabel = UILabel()
    }
    
    func setUpViewHeirarchy() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
    }
    
    func prepareForConstraints() {
        self.contentView.autoresizingMask = .flexibleHeight
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constrainViews() {
        _ = [
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8.0),
            self.detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            self.detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 8.0),
            self.detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            self.detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].map { $0.isActive = true }
    }
    
    func styleViews() {
        self.titleLabel.font = UIFont(name: "Avenir", size: 20)
        self.detailLabel.font = UIFont(name: "Avenir", size: 16)
        
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.detailLabel.numberOfLines = 0
        self.detailLabel.lineBreakMode = .byWordWrapping
        
        self.titleLabel.textColor = .black
        self.detailLabel.textColor = .gray
    }
}
