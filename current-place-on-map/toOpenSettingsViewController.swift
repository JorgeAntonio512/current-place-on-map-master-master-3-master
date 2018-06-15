//
//  toOpenSettingsViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 4/14/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class toOpenSettingsViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print("chyea chyea")
        let path = UIApplicationOpenSettingsURLString
        if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.openURL(settingsURL)
        }
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
                    print("heyheyhey")
                    DispatchQueue.main.async {
                        // Update UI
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted){
                    print("Location access was restricted.")
                    performSegue(withIdentifier: "awayFromOpenSetting", sender: self)
                }
                else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
                    print("User denied access to location.")
                    performSegue(withIdentifier: "awayFromOpenSetting", sender: self)
                }
                else if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
                    print("Location status not determined. your face!!")
                }
                else{
                    print("not getting location")
                    // a default pin
                }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "awayFromOpenSetting"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
                tabVC.navigationItem.hidesBackButton = true;
                tabVC.navigationController?.isNavigationBarHidden = true
            }
        }
    }
}
