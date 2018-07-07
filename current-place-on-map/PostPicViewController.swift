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
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        
        
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return postPicImageView
    }
}
