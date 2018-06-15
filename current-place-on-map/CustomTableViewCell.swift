//
//  CustomTableViewCell.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 5/7/18.
//  Copyright © 2018 William French. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class CustomTableViewCell: UITableViewCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Here you can customize the appearance of your cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.layer.borderWidth = 1.0
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.borderColor = UIColor.white.cgColor
        self.imageView?.frame = CGRect(x: 25, y: 5, width: 50, height: 50)
        self.imageView?.layer.cornerRadius = 25
        self.imageView?.clipsToBounds = true
        // Costomize other elements
        self.textLabel?.frame = CGRect(x: 90, y: 10, width: self.frame.width - 45, height: 20)
        self.detailTextLabel?.frame = CGRect(x: 90, y: 30, width: self.frame.width - 45, height: 15)
    }
}
