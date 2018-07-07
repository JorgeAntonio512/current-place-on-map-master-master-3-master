//
//  FriendsViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/14/18.
//  Copyright © 2018 William French. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher




class FriendsViewController: UITableViewController {
    
   // @IBOutlet var tableView: UITableView!
    
    struct Cake {
        var name = String()
        var height = String()
    }
    var yourValue:String?
    var yourRelStatus:String?
    var yourGender:String?
    var yourHeight:String?
    var yourZip:String?
    var yourAbout:String?
    var yourProPic:String?
    var theWey:String?
    var keyzy:String?
    var usersy:String?
    
    var usersArray = [ [String: Any] ]()
    var keyArray = [String]()
    var friendKeyArray = [String]()
    var selectedUser: User?
    
    var filteredData = [String]()
    
    var cakes = [Cake(name: "George (Organizer)", height: "6'4\""),
                 Cake(name: "Kyla (Co-Organizer)", height: "5'11\""),
                 Cake(name: "Lauren Constant", height: "5'11\""),
                 Cake(name: "Brian Grayson", height: "6'4\""),
                 Cake(name: "Stuart Rowe", height: "6'3\"")]
    //var messagesArray = [[String:String]]()
    
    
    
    
    var filteredCakes = [Cake]()
    
    let searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //filteredData = usersArray
        tableView.delegate = self
        tableView.dataSource = self
        //searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        //searchController.dimsBackgroundDuringPresentation = false
        //definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredCakes = cakes
        } else {
            // Filter the results
            // filteredCakes = usersArray.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.separatorInset = .zero
        cell.accessoryType = .disclosureIndicator
        let userDict = self.usersArray[indexPath.row]
        
        let url = URL(string: userDict["profileImageURL"] as! String)
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
        
        
        cell.textLabel?.text = userDict["name"] as? String
        cell.detailTextLabel?.text = userDict["height"] as? String
        //cell.textLabel?.text = self.filteredCakes[indexPath.row].name
        //cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].height
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let keeyzy = self.friendKeyArray[indexPath.row]
            let keyChain = DataService().keyChain
            if keyChain.get("uid") != nil {
                let FirebaseUid = keyChain.get("uid"); Database.database().reference().child("users").child(FirebaseUid!).child("friends").child(keeyzy).removeValue()
                usersArray.remove(at: indexPath.row)
                friendKeyArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade) // step 3
                
            
         
            self.tableView.reloadData()
            }}
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.usersArray[indexPath.row]
        let keysus = self.keyArray[indexPath.row]
        
        keyzy = keysus
        yourValue = dict["name"] as? String
        yourRelStatus = dict["status"] as? String
        yourGender = dict["gender"] as? String
        yourHeight = dict["height"] as? String
        yourZip = dict["city"] as? String
        yourAbout = dict["about"] as? String
        yourProPic = dict["profileImageURL"] as? String
        let islandRef = Storage.storage().reference(forURL: yourProPic!)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                
                let user = User.init(name: self.yourValue as! String, email: self.yourHeight as! String, id: self.keyzy!, profilePic: image!)
                self.selectedUser = user
                self.performSegue(withIdentifier: "toProfilezz", sender: self)
                
            }
            
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
    
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let ref = Database.database().reference().child("users/\(FirebaseUid!)/friends")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                if ( snapshot.value is NSNull ) {
                    print("not found")
                } else {
                    
                    self.usersArray.removeAll()
                    self.keyArray.removeAll()
                    self.friendKeyArray.removeAll()
                    
                    
                    for child in (snapshot.children) {
                        
                        
                        let snap = child as! DataSnapshot //each child is a snapshot
                        
                        let dict = snap.value as? [String:AnyObject] // the value is a dict
                        
                        let name = dict!["name"] as? String
                        
                        let friendKey = snap.key

                        
                        
                        let reffriend = Database.database().reference().child("users").queryOrdered(byChild: "name").queryEqual(toValue: name)
                        //.childByAutoId().queryEqual(toValue: "SDU93mBprghiEAmBFYHfA3MuaNF2")
                        
                        reffriend.observe(.value, with: { snapshot in
                            
                            if ( snapshot.value is NSNull ) {
                                print("not found")
                            } else {
                                
                                
                                
                                for child in (snapshot.children) {
                                    
                                    let snape = child as! DataSnapshot //each child is a snapshot
                                    
                                    let dicte = snape.value as? [String:AnyObject] // the value is a dict
                                    
                                    let key = snape.key
                                    
                                    self.usersArray.append(dicte!)
                                    self.keyArray.append(key)
                                    self.friendKeyArray.append(friendKey)
                                }
                                self.tableView.reloadData()
                                
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
            })}
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toProfilezz") {
            let vc = segue.destination as! PeoplezProfilesViewController
            vc.value = yourValue!
            vc.relVal = yourRelStatus!
            vc.genVal = yourGender!
            vc.heightVal = yourHeight!
            vc.zipVal = yourZip!
            vc.aboutVal = yourAbout!
            vc.proPicVal = yourProPic!
            print(self.selectedUser?.id)
            vc.selectedUser = selectedUser!
            
        }
    }
}


