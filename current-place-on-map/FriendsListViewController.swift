//
//  FriendsListViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 7/11/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit

class FriendsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
    }
    
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
