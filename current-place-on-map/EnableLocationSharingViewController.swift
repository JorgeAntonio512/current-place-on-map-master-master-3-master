//
//  EnableLocationSharingViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 3/30/18.
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

class EnableLocationSharingViewController: UIViewController {


    @IBOutlet var enableView: UIView!
    @IBOutlet weak var enableTop: UIButton!
    @IBOutlet weak var skipTop: UIButton!
    
    @IBOutlet weak var bottomBarOverlay: UIView!
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationItem.hidesBackButton = true
     
        print("yoyoyo")
        

        
    }

    
    @IBAction func enablePressed(_ sender: Any) {
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    @IBAction func skipPressed(_ sender: Any) {
        performSegue(withIdentifier: "tabBarShow", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tabBarShow"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
                tabVC.navigationItem.hidesBackButton = true;
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            performSegue(withIdentifier: "tabBarShow", sender: self)
        case .denied:
            print("User denied access to location.")
            performSegue(withIdentifier: "tabBarShow", sender: self)
        case .notDetermined:
            print("Location status not determined. blah blah.")
            
            
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is NOT OK>>>")
            DispatchQueue.main.async {
                // Update UI
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }

    }

extension EnableLocationSharingViewController: CLLocationManagerDelegate {
    // Handle authorization for the location manager.
    

}


