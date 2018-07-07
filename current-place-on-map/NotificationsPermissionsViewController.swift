//
//  NotificationsPermissionsViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 4/2/18.
//  Copyright © 2018 William French. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Foundation
import FacebookLogin
import Firebase
import KeychainSwift
import FBSDKLoginKit
import McPicker
import NVActivityIndicatorView
import UserNotifications

class NotificationsPermissionsViewController: UIViewController {
    

    @IBOutlet var viewy: UIView!
    @IBOutlet weak var enebled: UIButton!
    
    var notify: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    

    
    @IBAction func enabledz(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if granted {
                DispatchQueue.main.async {
                    if let refreshedToken = InstanceID.instanceID().token() {
                        print("InstanceID token: \(refreshedToken)")
                    
                        let keyChain = DataService().keyChain
                        if keyChain.get("uid") != nil {
                            let FirebaseUid = keyChain.get("uid")
                            //set up firebase references:
                            let FirebaseMessageRef = Database.database().reference()
                            //save the message in Firebase
                            FirebaseMessageRef.updateChildValues(["/users/\(FirebaseUid!)/token": refreshedToken])
                        }
                        
//                                let FirebaseMessageRef = Database.database().reference().child("tokens").childByAutoId()
//                                //save the message in Firebase
//                                FirebaseMessageRef.updateChildValues(["/token/": refreshedToken])
                        
                        
                        
                    }
                    // Update UI
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "backAgain", sender: self)
                })
                }
        }
        UIApplication.shared.registerForRemoteNotifications() // you can also set here for local notification.
    
    }
    
    @IBAction func skipzor(_ sender: Any) {
    performSegue(withIdentifier: "backAgain", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backAgain"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
                tabVC.navigationItem.hidesBackButton = true;
                tabVC.navigationController?.isNavigationBarHidden = true
            }
        }
    }
    
}
