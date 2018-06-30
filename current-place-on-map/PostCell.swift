//
//  PostCell.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 6/10/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    

@IBOutlet weak var textie:UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.layer.borderWidth = 1.0
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.borderColor = UIColor.white.cgColor
        self.imageView?.frame = CGRect(x: 25, y: 5, width: 50, height: 50)
        self.imageView?.layer.cornerRadius = 25
        self.imageView?.clipsToBounds = true
    }
}
