//
//  PostPageViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 6/10/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import KMPlaceholderTextView





class PostPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var pagePostImage: UIImageView!
    @IBOutlet weak var pagePostText: UITextView!
    @IBOutlet weak var leaveAcomment: KMPlaceholderTextView!
    @IBOutlet weak var commentBtn: UIButton!
    
    var pagePostPics:String?
    var pagePosts:String?
    var pageProfilePics:String?
    
    
    override func viewDidLoad() {
        leaveAcomment.layer.borderWidth = 1.0
        commentBtn.layer.borderWidth = 1.0
        
        leaveAcomment.layer.borderColor = UIColor.blue.cgColor
        commentBtn.layer.borderColor = UIColor.blue.cgColor
        
        if pagePostPics == "none"  {
            pagePostImage.isHidden = true
            pagePostText.text = pagePosts
        }
        if pagePosts == "none" {
            
            pagePostText.isHidden = true
            
            let url = URL(string: pagePostPics!)
            let imagur = #imageLiteral(resourceName: "notthere")
            pagePostImage.kf.setImage(with: url, placeholder: imagur, completionHandler: {
                (image, error, cacheType, imageUrl) in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    
                    print("deezzz imageview")
                }
                
            })
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.textie.text = pagePostPics! + pagePosts! + pageProfilePics!
        return cell
    }
    
    

}
