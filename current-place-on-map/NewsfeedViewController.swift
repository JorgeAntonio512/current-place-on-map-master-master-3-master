//
//  NewsfeedViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 3/11/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import Firebase





class NewsfeedViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    
    @IBOutlet var imagePreview: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()
    var usersArray = [ [String: Any] ]()
    var profilePic:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //filteredData = usersArray
        tableView.delegate = self
        tableView.dataSource = self
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    //Print user id from (User's device local storage):
    let keyChain = DataService().keyChain
    if keyChain.get("uid") != nil {
    let FirebaseUid = keyChain.get("uid")
    print("KEYCHAIN USER id: \(FirebaseUid!)")
    //set up firebase references:
        let FirebaseMessageRefAbout = Database.database().reference().child("posts")
    
        let FirebaseMessageRef6 = Database.database().reference().child("users/\(FirebaseUid!)/profileImageURL")
        // get a reference to our file store
        FirebaseMessageRef6.observe(.value) { (snap: DataSnapshot) in
            self.profilePic = (snap.value as AnyObject).description
            
            
            
            let islandRef = Storage.storage().reference(forURL: self.profilePic!)
            // let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pick = UIImage(data: data!)
                self.imagePreview.image = pick
                self.imagePreview.layer.borderWidth = 1.0
                self.imagePreview.layer.masksToBounds = true
                self.imagePreview.layer.borderColor = UIColor.white.cgColor
                self.imagePreview.frame = CGRect(x: 25, y: 15, width: 50, height: 50)
                self.imagePreview.layer.cornerRadius = 25
                self.imagePreview.clipsToBounds = true
//                self.pic.center = CGPoint(x: self.picCell.contentView.bounds.size.width/2,y: self.picCell.contentView.bounds.size.height/2)
//                
                
            }}
        }
    
    
    }
    
    @IBAction func AddImageButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    
    func writeAboutInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("posts").childByAutoId()
            //save the message in Firebase
            FirebaseMessageRef.updateChildValues(["/posts/": about])
        }
    }
    
    
    
    
    
    
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePreview.image  = tempImage
        //self.writeAboutInFirebase(about: self.post.text!)
        
        
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
        
        let child = UUID().uuidString
            let storageRef = Storage.storage().reference().child("postPics").child(child)
        let imageData = UIImageJPEGRepresentation(tempImage, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
            if err == nil {
                // let path = metadata?.downloadURL()?.absoluteString
                
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                    } else {
                        
                        let pathURL = url?.absoluteString
                        //let pathString = pathURL?.path
                        self.setUserInformation(profileImageURL: pathURL!, profilePic: self.profilePic!)
                        // Get the download URL for 'images/stars.jpg'
//                        let values = ["name": withName, "email": email, "profilePicLink": url?.absoluteString] as [String : Any]
//                        Database.database().reference().child("users").child((user?.user.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
//                            if errr == nil {
//                                let userInfo = ["email" : email, "password" : password]
//                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
//                                completion(true)
                          //  }
                        //})
                    }
                }
                
            }
        })}
        
        
        
        
        
        
        self.dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        
        self.dismiss(animated: true)
    }
    
    // MARK: - Firebase Saving Methods
    
    func setUserInformation(profileImageURL: String, profilePic: String) {
        // create the new user in the user node and store username, email, and profile image URL
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            
            
            let uid = FirebaseUid
            
            let ref = Database.database().reference()
            let userReference = ref.child("posts").childByAutoId()
            //let newUserReference = userReference.child(uid!)
            //let FirebaseMessageRef = Database.database().reference().child("posts").childByAutoId()
            //save the message in Firebase
            userReference.updateChildValues(["/postPics/": profileImageURL, "/posts/": "none", "/profilePics/": profilePic])
            //userReference.updateChildValues(["posts": profileImageURL])
        }
        
    }
}






