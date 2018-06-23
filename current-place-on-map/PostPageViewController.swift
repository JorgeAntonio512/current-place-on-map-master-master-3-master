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
    var thestampp:TimeInterval?
    
    
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
    func writeCommentInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let ref = Database.database().reference().child("posts").childByAutoId()
            let FirebaseMessageRef = ref.queryEqual(toValue: thestampp, childKey: "timestamp")
            //save the message in Firebase
            let interval = NSDate().timeIntervalSince1970
           
            FirebaseMessageRef.observeSingleEvent(of: .childAdded) { (snapshot) in
                let newRef = snapshot.ref.child("comment")
                newRef.setValue(about)
                }
            Database.database().reference().child("posts").queryOrdered(byChild: "timestamp").queryEqual(toValue: thestampp).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print("FRIEND ALREADY EXISTS!")
                } else {
                    print("FRIEND DOES NOT EXIST! ESTABLISHING FRIENDSHIP:")
                    print(self.thestampp as Any)
                    //self.dismiss(animated: true, completion: nil)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            //FirebaseMessageRef.updateChildValues(["/comments/": about])
            //FirebaseMessageRef.updateChildValues(["/profilePics/": profilePics])
        }
    }
    
    
    @IBAction func leaveComment(_ sender: Any) {
        if leaveAcomment.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "You haven't given us anything to share!", message:
                "Please come up with something!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.writeCommentInFirebase(about: self.leaveAcomment.text)
            
            //navigationController?.popViewController(animated: true)
            //        let alertController = UIAlertController(title: "Your post has been shared!", message:
            //            "Please press the \"Back\" button!", preferredStyle: UIAlertControllerStyle.alert)
            //        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            //
            //        self.present(alertController, animated: true, completion: nil)
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
