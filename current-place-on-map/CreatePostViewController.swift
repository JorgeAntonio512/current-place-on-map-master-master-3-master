//
//  CreatePostViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 3/11/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Firebase

class CreatePostViewController: UIViewController {
    @IBOutlet weak var post: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var Namename: UITextView!
    
    var profilePics:String?
    var namey:String?
    
    override func viewDidAppear(_ animated: Bool) {
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRefName = Database.database().reference().child("users/\(FirebaseUid!)/name")
                FirebaseMessageRefName.observe(.value) { (snap: DataSnapshot) in
                    let profileName = (snap.value as AnyObject).description
            
                    self.Namename.text = profileName
            }
                    
            let FirebaseMessageRef6 = Database.database().reference().child("users/\(FirebaseUid!)/profileImageURL")
            // get a reference to our file store
            FirebaseMessageRef6.observe(.value) { (snap: DataSnapshot) in
                self.profilePics = (snap.value as AnyObject).description
                
                
                
                let islandRef = Storage.storage().reference(forURL: self.profilePics!)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                islandRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pick = UIImage(data: data!)
                    self.profilePic.image = pick
                    self.profilePic.layer.borderWidth = 1.0
                    self.profilePic.layer.masksToBounds = true
                    self.profilePic.layer.borderColor = UIColor.white.cgColor
                    self.profilePic.frame = CGRect(x: 25, y: 60, width: 50, height: 50)
                    self.profilePic.layer.cornerRadius = 25
                    self.profilePic.clipsToBounds = true
                    
                }}
        }}
    
    func writeAboutInFirebase(about: String, profilePics: String, namey: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("posts").childByAutoId()
            //save the message in Firebase
            let interval = NSDate().timeIntervalSince1970
            FirebaseMessageRef.updateChildValues(["/posts/": about, "/postPics/": "none", "/profilePics/": profilePics, "/name/": namey, "/timestamp/": interval])
        }
    }
    
    
    @IBAction func shareTapped(_ sender: Any) {
        if post.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "You haven't given us anything to share!", message:
                "Please come up with something!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.writeAboutInFirebase(about: self.post.text!, profilePics: profilePics!, namey: self.Namename.text!)
         
            navigationController?.popViewController(animated: true)
        }
    }
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }



}
