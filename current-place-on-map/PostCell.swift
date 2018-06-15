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
        self.textie.text = "hello there, General Kenobi!"
    }
}
