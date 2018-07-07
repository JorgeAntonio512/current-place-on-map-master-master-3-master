//
//  PostPicViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 7/7/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit

class PostPicViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var postPic: String?
    
    @IBOutlet weak var postPicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: postPic!)
        let imagur = #imageLiteral(resourceName: "notthere")
        postPicImageView.kf.setImage(with: url, placeholder: imagur, completionHandler: {
            (image, error, cacheType, imageUrl) in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
            }
            
        })
    }
    @IBAction func savePhoto(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(postPicImageView.image!)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    
    }
}
