//
//  PeoplezProfilesViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/7/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Firebase
import FirebaseStorage

class PeoplezProfilesViewController: UITableViewController {
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var relstatus: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var about: UITextView!
    
    @IBOutlet weak var profilePicCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var genderCell: UITableViewCell!
    @IBOutlet weak var heightCell: UITableViewCell!
    @IBOutlet weak var bioCell: UITableViewCell!
    @IBOutlet weak var relCell: UITableViewCell!
    @IBOutlet weak var zipCell: UITableViewCell!
    
    @IBOutlet weak var addFriendPic: UIImageView!
    
    @IBOutlet weak var addFriendBtn: UIButton!
    var value = ""
    var relVal = ""
    var genVal = ""
    var heightVal = ""
    var zipVal = ""
    var aboutVal = ""
    var proPicVal = ""
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = value
        relstatus.text = relVal
        gender.text = genVal
        height.text = heightVal
        zip.text = zipVal
        about.text = aboutVal
       
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
            //Select the correct user
            let keyChain = DataService().keyChain
            if keyChain.get("uid") != nil {
                let FirebaseUid = keyChain.get("uid")
                let data = ["friend": self.selectedUser?.id, "name": name.text]
                
                
                let username = name.text
                Database.database().reference().child("users").child(FirebaseUid!).child("friends").queryOrdered(byChild: "name").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        self.addFriendBtn.isHidden = true
                        self.addFriendPic.isHidden = true
                    } else {
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                //self.performSegue(withIdentifier: "toFriendsList", sender: self)
            }
            
        
        
        
        
        
        
        
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
        
        if proPicVal != "" {
            
            // Create a reference to the file you want to download
            let islandRef = Storage.storage().reference(forURL: proPicVal)
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.profilePicImage.image = image
                    self.profilePicImage.layer.borderWidth = 1
                    self.profilePicImage.layer.masksToBounds = false
                    self.profilePicImage.layer.borderColor = UIColor.black.cgColor
                    self.profilePicImage.frame = CGRect(x: 20, y: 20, width: 110, height: 110)
                    self.profilePicImage.layer.cornerRadius = self.profilePicImage.frame.height / 2
                    self.profilePicImage.clipsToBounds = true
                    self.profilePicImage.center = CGPoint(x: self.profilePicCell.contentView.bounds.size.width/2,y: self.profilePicCell.contentView.bounds.size.height/2)
                }
            }
            
            
            
        }
  
        
        
    }
    @IBAction func addFriendPushed(_ sender: Any) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            let data = ["friend": self.selectedUser?.id, "name": name.text]
           
            
            let username = name.text
            Database.database().reference().child("users").child(FirebaseUid!).child("friends").queryOrdered(byChild: "name").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                } else {
                    Database.database().reference().child("users").child(FirebaseUid!).child("friends").childByAutoId().updateChildValues(data)
                    self.addFriendBtn.isHidden = true
                    self.addFriendPic.isHidden = true
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }

    
    
    
    @IBAction func messagePushed(_ sender: Any) {
    self.performSegue(withIdentifier: "toChat", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            let vc = segue.destination as! ChatVC
            print(self.selectedUser?.id)
            vc.currentUser = self.selectedUser
        }
    }

    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
}

