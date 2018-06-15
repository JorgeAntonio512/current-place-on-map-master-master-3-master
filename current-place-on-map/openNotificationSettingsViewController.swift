//
//  openNotificationSettingsViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 4/14/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class openNotificationSettingsViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func pressedIt(_ sender: AnyObject) {
        print("chyea chyea")
        let path = UIApplicationOpenSettingsURLString
        if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.openURL(settingsURL)
        }
    }
    
    @IBAction func closeNotificationSettings(_ sender: Any) {
    
   
    
    
                let current = UNUserNotificationCenter.current()
        
                current.getNotificationSettings(completionHandler: { (settings) in
                    if settings.authorizationStatus == .notDetermined {
                        // Notification permission has not been asked yet, go for it!
                        print ("FIND OUT!!")
                    }
        
                    if settings.authorizationStatus == .denied {
                        // Notification permission was previously denied, go to settings & privacy to re-enable
                        DispatchQueue.main.async(execute: {
                            print ("it's denied, from openNotificationSettings!")
                            //self.performSegue(withIdentifier: "backAgain", sender: self)
                            self.performSegue(withIdentifier: "awayFromNotificationSettings", sender: self)
                        })
                    }
        
                    if settings.authorizationStatus == .authorized {
                        // Notification permission was already granted
                        DispatchQueue.main.async(execute: {
                                // Update UI
                                self.navigationController?.popViewController(animated: true)
                            
                        })
                    }
                })
    
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "awayFromNotificationSettings"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
                tabVC.navigationItem.hidesBackButton = true;
                tabVC.navigationController?.isNavigationBarHidden = true
            }
        }
    }
}
