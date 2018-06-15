//
//  NewsfeedTableViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 5/17/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewsfeedTableViewController: UIViewController {

    var usersArray = [ [String: Any] ]()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRefAbout = Database.database().reference().child("posts")
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 140
        }
        
        let ref = Database.database().reference().child("posts")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    
                    let dict = snap.value as? [String:AnyObject] // the value is a dict
                    
                    //let name = dict!["posts"] as? String
                    //let food = dict!["height"] as? String
                    let key = snap.key
                    print(key)
                    //print("\(name) loves \(food)")
                    self.usersArray.append(dict!)
                    print(self.usersArray)
                    //self.postsName.text = dict!["posts"] as? String
                    //self.keyArray.append(key)
                }
                self.tableView.reloadData()
            }
            
        })
        
    }

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        //let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let userDict = self.usersArray[indexPath.row]
        //let cell: PostImageCell = PostImageCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
        let imageURL = URL(string: userDict["postPics"] as! String)
        cell.postImageView.kf.setImage(with: imageURL)
        //cell.separatorInset = .zero
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = #imageLiteral(resourceName: "notthere")
        
        
        
        
        let url = URL(string: userDict["profilePics"] as! String)
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
        
        
//        let url = URL(string: userDict["profileImageURL"] as! String)
//        let imagur = #imageLiteral(resourceName: "notthere")
//        cell.imageView?.kf.setImage(with: url, placeholder: imagur, completionHandler: {
//            (image, error, cacheType, imageUrl) in
//            if let error = error {
//                // Uh-oh, an error occurred!
//            } else {
//
//                print("deezzz imageview")
//            }
//            // image: Image? `nil` means failed
//            // error: NSError? non-`nil` means failed
//            // cacheType: CacheType
//            //                  .none - Just downloaded
//            //                  .memory - Got from memory cache
//            //                  .disk - Got from disk cache
//            // imageUrl: URL of the image
//        })
        
        
        
        
        
        cell.textLabel?.text = userDict["posts"] as? String
        cell.detailTextLabel?.text = userDict["height"] as? String
        print("you like CDs??")
        //cell.textLabel?.text = self.filteredCakes[indexPath.row].name
        //cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].height
        
        
        return cell
    }
    

}
