//
//  PostImageCell.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 6/2/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit

class PostImageCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var nameLabele: UILabel!
    @IBOutlet weak var postText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        
        self.postImageView.layer.borderWidth = 1.0
        self.postImageView.layer.masksToBounds = true
        self.postImageView.layer.borderColor = UIColor.white.cgColor
        self.postImageView.frame = CGRect(x: 230, y: 20, width: 100, height: 100)
        self.postImageView.layer.cornerRadius = 25
        self.postImageView.clipsToBounds = true
    }
}
