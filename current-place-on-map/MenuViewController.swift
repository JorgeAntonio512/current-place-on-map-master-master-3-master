//
//  MenuViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/4/18.
//  Copyright © 2018 William French. All rights reserved.
//

import UIKit
import GooglePlaces
import FacebookLogin
import Firebase
import KeychainSwift
import FBSDKLoginKit

class MenuViewController: UITableViewController {
   
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var SignOff: UILabel!
    @IBOutlet weak var meetup: UILabel!
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var twitter: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let twitterGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(twitterTapAction))
        let facebookGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fbTapAction))
        let meetupGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapActionzz))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let SignOffgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapActionz))
        self.contact.addGestureRecognizer(gestureRecognizer)
        self.SignOff.addGestureRecognizer(SignOffgestureRecognizer)
        
        self.meetup.addGestureRecognizer(meetupGestureRecognizer)
        
        self.facebook.addGestureRecognizer(facebookGestureRecognizer)
        
        self.twitter.addGestureRecognizer(twitterGestureRecognizer)
    
    }
    
    
    
    /* will be called when tapping on the label */
    @objc func tapAction() -> Void {
        UIApplication.shared.open(URL(string: "mailto:austintallcommunity@gmail.com")! as URL, options: [:], completionHandler: nil)
    }
    @objc func tapActionz() -> Void {
        //here I want to execute the UIActionSheet
        let actionsheet = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action) -> Void in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let manager = FBSDKLoginManager()
            manager.logOut()
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            print("Facebook loggedout")
            DataService().keyChain.delete("uid")
            self.performSegue(withIdentifier: "backtoBegin", sender: nil)
            //dismiss(animated: true, completion: nil)
        
        
        }))
        
       
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion:{})
        
                
        
              //  myVC?.present(actionsheet, animated: true, completion: nil)
        
        
    }
    @objc func tapActionzz() -> Void {
        print("you are here in tapActionzz")
        let FirebaseMessageRef1 = Database.database().reference().child("webpages/Meetup")
        //Write value from Firebase database to the label:
        FirebaseMessageRef1.observe(.value) { (snap: DataSnapshot) in
            let webpage = snap.value as! String
            
            //let myURL = URL(string: webpage)
            //let myRequest = URLRequest(url: myURL!)
            //self.webView.load(myRequest)
            //
            guard let url = URL(string: webpage) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func fbTapAction() -> Void {
        print("you are here in tapActionzz")
        let FirebaseMessageRef1 = Database.database().reference().child("webpages/Facebook")
        //Write value from Firebase database to the label:
        FirebaseMessageRef1.observe(.value) { (snap: DataSnapshot) in
            let webpage = snap.value as! String
            
            //let myURL = URL(string: webpage)
            //let myRequest = URLRequest(url: myURL!)
            //self.webView.load(myRequest)
            //
            guard let url = URL(string: webpage) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func twitterTapAction() -> Void {
        print("you are here in tapActionzz")
        let FirebaseMessageRef1 = Database.database().reference().child("webpages/Twitter")
        //Write value from Firebase database to the label:
        FirebaseMessageRef1.observe(.value) { (snap: DataSnapshot) in
            let webpage = snap.value as! String
            
            //let myURL = URL(string: webpage)
            //let myRequest = URLRequest(url: myURL!)
            //self.webView.load(myRequest)
            //
            guard let url = URL(string: webpage) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    


    
    
//    @IBAction func onEmailButtonWasPressed(_ sender: Any) {
//    UIApplication.shared.open(URL(string: "mailto:austintallcommunity@gmail.com")! as URL, options: [:], completionHandler: nil)
//}


}
