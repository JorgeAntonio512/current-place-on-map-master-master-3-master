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
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
                }
                
            })
        }
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
        
        let FirebaseMessageRefName = Database.database().reference().child("users/\(FirebaseUid!)/name")
        FirebaseMessageRefName.observe(.value) { (snap: DataSnapshot) in
            self.namedname = (snap.value as AnyObject).description
            
        }
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pagePostImage.isUserInteractionEnabled = true
        pagePostImage.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if (tapGestureRecognizer.view as? UIImageView) != nil {
            print("ImageTapped")
            performSegue(withIdentifier: "toPostPicView", sender: self)
        }
        
        // Your action
    }
    
    func writeCommentInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
           
                }
            let ref = Database.database().reference().child("posts")
            let query = ref.queryOrdered(byChild: "timestamp").queryEqual(toValue: thestampp)
                
                query.observeSingleEvent(of: .childAdded) { (snapshot) in
                    let newRef = snapshot.ref
                    let interval = NSDate().timeIntervalSince1970
                    newRef.child("comments").childByAutoId().updateChildValues(["/comment/": about, "/name/": self.namedname as Any, "/timestamp/": interval, "/profilePic/": self.pageProfilePics as Any])        }
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
                
                    let key = snap.key
                    
                    
                    ref.child(key).child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
                        for child in (snapshot.children) {
                            let snap = child as! DataSnapshot //each child is a snapshot
                            
                            let dict = snap.value as? [String:AnyObject]
                            
                                
                            self.commentArray.insert(dict!, at: 0)
                        }
                         self.tableView.reloadData()
                        
                    })
                
                            
                
            }
            
            }})
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
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
        
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "CST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy" //Specify your format that you want
            
            let timeString = (NSDate(timeIntervalSince1970: userDict["timestamp"] as! TimeInterval).timeAgoSinceNow()) as  String
            
            
            cell.dateNtime.text = timeString
        }
     
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toPostPicView") {
            let vc = segue.destination as! PostPicViewController
            vc.postPic = pagePostPics
        }
    }

}
