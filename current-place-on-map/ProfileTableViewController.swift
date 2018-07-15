//
//  ProfileTableViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/4/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import FacebookLogin
import Firebase
import FirebaseStorage
import KeychainSwift
import FBSDKLoginKit
import McPicker
import NVActivityIndicatorView

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var picCell: UITableViewCell!
    
    
    @IBOutlet weak var saveCell: UITableViewCell!
    @IBOutlet weak var bioCell: UITableViewCell!
    @IBOutlet weak var zipCell: UITableViewCell!
    @IBOutlet weak var relCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    
    @IBOutlet weak var heightCell: UITableViewCell!
    @IBOutlet weak var genderCell: UITableViewCell!
    
    
    let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 32), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  
            
        let toplineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView.layer.borderWidth = 1.0
        toplineView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameCell.addSubview(toplineView)
        
        
        let toplineView1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView1.layer.borderWidth = 1.0
        toplineView1.layer.borderColor = UIColor.lightGray.cgColor
        self.genderCell.addSubview(toplineView1)
        
        let toplineView2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView2.layer.borderWidth = 1.0
        toplineView2.layer.borderColor = UIColor.lightGray.cgColor
        self.heightCell.addSubview(toplineView2)
        
        let toplineView3 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView3.layer.borderWidth = 1.0
        toplineView3.layer.borderColor = UIColor.lightGray.cgColor
        self.relCell.addSubview(toplineView3)
        
        
        let toplineView4 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView4.layer.borderWidth = 1.0
        toplineView4.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCell.addSubview(toplineView4)
        
        let toplineView5 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView5.layer.borderWidth = 1.0
        toplineView5.layer.borderColor = UIColor.lightGray.cgColor
        self.bioCell.addSubview(toplineView5)
        
        let toplineView6 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView6.layer.borderWidth = 1.0
        toplineView6.layer.borderColor = UIColor.lightGray.cgColor
        self.saveCell.addSubview(toplineView6)
        
        
        
        
        let bottomlineView = UIView(frame: CGRect(x: 0, y: self.nameCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView.layer.borderWidth = 1.0
        bottomlineView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameCell.addSubview(bottomlineView)
        
        
        let bottomlineView2 = UIView(frame: CGRect(x: 0, y: self.heightCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView2.layer.borderWidth = 1.0
        bottomlineView2.layer.borderColor = UIColor.lightGray.cgColor
        self.heightCell.addSubview(bottomlineView2)
        
        let bottomlineView3 = UIView(frame: CGRect(x: 0, y: self.relCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView3.layer.borderWidth = 1.0
        bottomlineView3.layer.borderColor = UIColor.lightGray.cgColor
        self.relCell.addSubview(bottomlineView3)
        
        
        let bottomlineView4 = UIView(frame: CGRect(x: 0, y: self.zipCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView4.layer.borderWidth = 1.0
        bottomlineView4.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCell.addSubview(bottomlineView4)
        
        
        let bottomlineView5 = UIView(frame: CGRect(x: 0, y: self.bioCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView5.layer.borderWidth = 1.0
        bottomlineView5.layer.borderColor = UIColor.lightGray.cgColor
        self.bioCell.addSubview(bottomlineView5)
        
        let bottomlineView6 = UIView(frame: CGRect(x: 0, y: self.saveCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView6.layer.borderWidth = 1.0
        bottomlineView6.layer.borderColor = UIColor.lightGray.cgColor
        self.saveCell.addSubview(bottomlineView6)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("users/\(FirebaseUid!)/name")
            //Write value from Firebase database to the label:
            FirebaseMessageRef.observe(.value) { (snap: DataSnapshot) in
                self.name.text = (snap.value as AnyObject).description
            }
            let FirebaseMessageRef1 = Database.database().reference().child("users/\(FirebaseUid!)/gender")
            //Write value from Firebase database to the label:
            FirebaseMessageRef1.observe(.value) { (snap: DataSnapshot) in
                self.gender.text = (snap.value as AnyObject).description
            }
            
            let FirebaseMessageRef2 = Database.database().reference().child("users/\(FirebaseUid!)/height")
            //Write value from Firebase database to the label:
            FirebaseMessageRef2.observe(.value) { (snap: DataSnapshot) in
                self.height.text = (snap.value as AnyObject).description
            }
            let FirebaseMessageRef3 = Database.database().reference().child("users/\(FirebaseUid!)/city")
         
            let FirebaseMessageRef4 = Database.database().reference().child("users/\(FirebaseUid!)/about")
            FirebaseMessageRef3.observe(.value) { (snap: DataSnapshot) in
                self.zipcode.text = (snap.value as AnyObject).description
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRef4.observe(.value) { (snap: DataSnapshot) in
                self.about.text = (snap.value as AnyObject).description
            }
            let FirebaseMessageRef5 = Database.database().reference().child("users/\(FirebaseUid!)/status")
            //Write value from Firebase database to the label:
            FirebaseMessageRef5.observe(.value) { (snap: DataSnapshot) in
                self.status.text = (snap.value as AnyObject).description
            }
            // Create a storage reference from the URL
            let uid = FirebaseUid
            
            
            self.loadingIndicator.startAnimating();
            
            self.pic.addSubview(self.loadingIndicator)
            self.loadingIndicator.center = CGPoint(x: self.picCell.contentView.bounds.size.width/2,y: self.picCell.contentView.bounds.size.height/2)
            
            
            let FirebaseMessageRef6 = Database.database().reference().child("users/\(FirebaseUid!)/profileImageURL")
            // get a reference to our file store
            FirebaseMessageRef6.observe(.value) { (snap: DataSnapshot) in
                let profilePic = (snap.value as AnyObject).description
                
                
            
                let islandRef = Storage.storage().reference(forURL: profilePic!)
           // let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pick = UIImage(data: data!)
                self.pic.image = pick
                self.loadingIndicator.stopAnimating()
                self.pic.layer.borderWidth = 1
                self.pic.layer.masksToBounds = false
                self.pic.layer.borderColor = UIColor.black.cgColor
                self.pic.frame = CGRect(x: 20, y: 20, width: 110, height: 110)
                self.pic.layer.cornerRadius = self.pic.frame.height / 2
                self.pic.clipsToBounds = true
                self.pic.center = CGPoint(x: self.picCell.contentView.bounds.size.width/2,y: self.picCell.contentView.bounds.size.height/2)
            
                
                }}
            self.tableView.allowsSelection = false
        }
    }
   
}


