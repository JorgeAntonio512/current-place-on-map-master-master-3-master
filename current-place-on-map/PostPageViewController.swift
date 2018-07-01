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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagePostImage: UIImageView!
    @IBOutlet weak var pagePostText: UITextView!
    @IBOutlet weak var leaveAcomment: KMPlaceholderTextView!
    @IBOutlet weak var commentBtn: UIButton!
    
    var pagePostPics:String?
    var pagePosts:String?
    var pageProfilePics:String?
    var thestampp:TimeInterval?
    
    var namedname:String?
    
    var commentArray = [ [String: Any] ]()
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        leaveAcomment.layer.borderWidth = 1.0
        commentBtn.layer.borderWidth = 1.0
        
        leaveAcomment.layer.borderColor = UIColor.blue.cgColor
        commentBtn.layer.borderColor = UIColor.blue.cgColor
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10.0
        
        
        if pagePostPics == "none"  {
            scrollView.isHidden = true
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
        //Print user id from (User's device local storage):
        //let keyChain = DataService().keyChain
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
        
        let FirebaseMessageRefName = Database.database().reference().child("users/\(FirebaseUid!)/name")
        FirebaseMessageRefName.observe(.value) { (snap: DataSnapshot) in
            self.namedname = (snap.value as AnyObject).description
            
            print(self.namedname! + "hell no it works!")
            //self.Namename.text = profileName
        }
        }
    }
    func writeCommentInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            //let ref = Database.database().reference().child("posts").childByAutoId()
            //let FirebaseMessageRef = ref.queryEqual(toValue: thestampp, childKey: "timestamp")
            //save the message in Firebase
            let interval = NSDate().timeIntervalSince1970
           
            //FirebaseMessageRef.observeSingleEvent(of: .childAdded) { (snapshot) in
               // let newRef = snapshot.ref.child("comment")
                //newRef.setValue(about)
                }
            let ref = Database.database().reference().child("posts")
            let query = ref.queryOrdered(byChild: "timestamp").queryEqual(toValue: thestampp)
                
                query.observeSingleEvent(of: .childAdded) { (snapshot) in
                    print("FRIEND ALREADY EXISTS!")
                    let newRef = snapshot.ref
                    newRef.child("comments").childByAutoId().updateChildValues(["/comment/": about, "/name/": self.namedname as Any, "/timestamp/": self.thestampp as Any, "/profilePic/": self.pageProfilePics as Any])        }
    leaveAcomment.text.removeAll()
        commentArray.removeAll()
       updateComments()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        commentArray.removeAll()
        updateComments()
        
        
    }
    
    func updateComments() {
        let ref = Database.database().reference().child("posts")
        let query = ref.queryOrdered(byChild: "timestamp").queryEqual(toValue: thestampp)
        
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as? [String:AnyObject] // the value is a dict
                    
                    //let name = dict!["posts"] as? String
                    //let food = dict!["height"] as? String
                    let key = snap.key
                    
                    
                    ref.child(key).child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
                      
                       print("well im here..")
                        for child in (snapshot.children) {
                            print("and now here?")
                            let snap = child as! DataSnapshot //each child is a snapshot
                            
                            let dict = snap.value as? [String:AnyObject]
                            
                               // postsCommentsDict.setObject(each["userName"] as! String , forKey : each["userComment"] as! String)
                                //Saving the userName : UserComment in a dictionary
                               // userNameArray.append(each["userName"] as! String)
                               // userCommentArray.append(each["userComment"] as! String)
                                //Saving the details in arrays
                                //Prefer dictionary over Arrays
                                
                            self.commentArray.insert(dict!, at: 0)
                            print("THIS IS THE AWESOME", self.commentArray)
                        }
                         self.tableView.reloadData()
                        
                    })
                
                            
                        
                    print(key)
                    //print("\(name) loves \(food)")
                    //self.usersArray.append(dict!)
                    
                    print(dict!["comments"] as Any)
                    //self.postsName.text = dict!["posts"] as? String
                    //self.keyArray.append(key)
                
                
            }
            
            }})
       
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return pagePostImage
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userDict = self.commentArray[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
    
        
        let url = URL(string: userDict["profilePic"] as! String)
        let imagur = #imageLiteral(resourceName: "notthere")
        cell.imageView?.kf.setImage(with: url, placeholder: imagur, completionHandler: {
            (image, error, cacheType, imageUrl) in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                
                print("deezzz imageview")
            }
            // image: Image? `nil` means failed
            // error: NSError? non-`nil` means failed
            // cacheType: CacheType
            //                  .none - Just downloaded
            //                  .memory - Got from memory cache
            //                  .disk - Got from disk cache
            // imageUrl: URL of the image
        })
        
        
        DispatchQueue.main.async {
            // Update UI
            cell.textie.text = userDict["comment"] as? String
            cell.namedCell.text = userDict["name"] as? String
        }
     
        
        return cell
    }
    
    

}
