//
//  NewNewsfeedViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 6/2/18.
//  Copyright © 2018 William French. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DateTools





class NewNewsfeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var nameLabele: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    var profilePic:String?
    var usersArray = [ [String: Any] ]()
    var imagePicker = UIImagePickerController()
    
    var postPics:String?
    var posts:String?
    var profilePics:String?
    var timestampzz:TimeInterval?
    var nameyname:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    
    
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRefAbout = Database.database().reference().child("posts")
            
            NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
                self?.tableView.reloadData()
            }
            
        }
        
        
        
        
        //Print user id from (User's device local storage):
        //let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRefAbout = Database.database().reference().child("posts")
            
           
            //let uid = FirebaseUid
            
            let FirebaseMessageRefName = Database.database().reference().child("users/\(FirebaseUid!)/name")
            FirebaseMessageRefName.observe(.value) { (snap: DataSnapshot) in
                self.nameyname = (snap.value as AnyObject).description
                
                print(self.nameyname! + "hell no it works!")
                //self.Namename.text = profileName
            }
            
            
            let FirebaseMessageRef6 = Database.database().reference().child("users/\(FirebaseUid!)/profileImageURL")
            // get a reference to our file store
            FirebaseMessageRef6.observe(.value) { (snap: DataSnapshot) in
                self.profilePic = (snap.value as AnyObject).description
                
                
                
                let islandRef = Storage.storage().reference(forURL: self.profilePic!)
                // let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                islandRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    let pick = UIImage(data: data!)
                    self.imagePreview.image = pick
                    self.imagePreview.layer.borderWidth = 1.0
                    self.imagePreview.layer.masksToBounds = true
                    self.imagePreview.layer.borderColor = UIColor.white.cgColor
                    self.imagePreview.frame = CGRect(x: 25, y: 15, width: 50, height: 50)
                    self.imagePreview.layer.cornerRadius = 25
                    self.imagePreview.clipsToBounds = true
                    //                self.pic.center = CGPoint(x: self.picCell.contentView.bounds.size.width/2,y: self.picCell.contentView.bounds.size.height/2)
                    //
                    
                }}
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        usersArray.removeAll()
        updatePosts()
     
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
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
        
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
        //let FirebaseNameRef = Database.database().reference().child("users/\(FirebaseUid!)/name")
       // let FirebaseNameRef = Database.database().reference().child("posts").childByAutoId().child("name")
        //FirebaseNameRef.observe(.value) { (snap: DataSnapshot) in
            
            
            
            
            
            }
    cell.nameLabele.text = userDict["name"] as? String
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy" //Specify your format that you want
        //let timeString = "\(dateFormatter.string(from: NSDate(timeIntervalSince1970: userDict["timestamp"] as! TimeInterval) as Date))"
        
        let timeString = (NSDate(timeIntervalSince1970: userDict["timestamp"] as! TimeInterval).timeAgoSinceNow()) as  String
        
       
    cell.dateTime.text = timeString
        
        if userDict["posts"] as? String == "none" {
            cell.postText.text = nil
            cell.postText.isHidden = true
        } else {
            cell.postText.isHidden = false
            cell.postText.text = userDict["posts"] as? String
        }
        cell.detailTextLabel?.text = userDict["height"] as? String
        print("you like CDs??")
        //cell.textLabel?.text = self.filteredCakes[indexPath.row].name
        //cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].height
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.usersArray[indexPath.row]
        
        postPics = dict["postPics"] as? String
        posts = dict["posts"] as? String
        profilePics = dict["profilePics"] as? String
        timestampzz = dict["timestamp"] as? TimeInterval
        print("this is the STAMP:", timestampzz as Any)
//        let keysus = self.keyArray[indexPath.row]
//
//        keyzy = keysus
//        yourValue = dict["name"] as? String
//        yourRelStatus = dict["status"] as? String
//        yourGender = dict["gender"] as? String
//        yourHeight = dict["height"] as? String
//        yourZip = dict["city"] as? String
//        yourAbout = dict["about"] as? String
//        yourProPic = dict["profileImageURL"] as? String
//        let islandRef = Storage.storage().reference(forURL: yourProPic!)
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        islandRef.getData(maxSize: 10 * 1024 * 1024) { data,fnumbe error in
//            if let error = error {
//                // Uh-oh, an error occurred!
//            } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//
//                let user = User.init(name: self.yourValue as! String, email: self.yourHeight as! String, id: self.keyzy!, profilePic: image!)
//                print(self.keyzy! + "this is the keyzy fosheezy!")
//                self.selectedUser = user
                self.performSegue(withIdentifier: "toPostPage", sender: self)
                
           // }
            
       // }
        
    }
    
    func updatePosts() {
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
                    //self.usersArray.append(dict!)
                    self.usersArray.insert(dict!, at: 0)
                    print(self.usersArray)
                    //self.postsName.text = dict!["posts"] as? String
                    //self.keyArray.append(key)
                }
                self.tableView.reloadData()
            }
            
        })
    }
    
    @IBAction func AddImageButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    
    
    func writeAboutInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("posts").childByAutoId()
            //save the message in Firebase
            FirebaseMessageRef.updateChildValues(["/posts/": about])
        }
    }
    
    
    
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //imagePreview.image  = tempImage
        //self.writeAboutInFirebase(about: self.post.text!)
        
        
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            
            let child = UUID().uuidString
            let storageRef = Storage.storage().reference().child("postPics").child(child)
            let imageData = UIImageJPEGRepresentation(tempImage, 0.1)
            storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                if err == nil {
                    // let path = metadata?.downloadURL()?.absoluteString
                    
                    
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            // Handle any errors
                        } else {
                            
                            let pathURL = url?.absoluteString
                            //let pathString = pathURL?.path
                            self.setUserInformation(profileImageURL: pathURL!, profilePic: self.profilePic!)
                            self.usersArray.removeAll()
                            self.updatePosts()
                            // Get the download URL for 'images/stars.jpg'
                            //                        let values = ["name": withName, "email": email, "profilePicLink": url?.absoluteString] as [String : Any]
                            //                        Database.database().reference().child("users").child((user?.user.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            //                            if errr == nil {
                            //                                let userInfo = ["email" : email, "password" : password]
                            //                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                            //                                completion(true)
                            //  }
                            //})
                        }
                    }
                    
                }
            })}
        
        
        
        self.dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        
        self.dismiss(animated: true)
    }
    
    // MARK: - Firebase Saving Methods
    
    func setUserInformation(profileImageURL: String, profilePic: String) {
        // create the new user in the user node and store username, email, and profile image URL
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            
            
           
            
            let ref = Database.database().reference()
            let userReference = ref.child("posts").childByAutoId()
            //let newUserReference = userReference.child(uid!)
            //let FirebaseMessageRef = Database.database().reference().child("posts").childByAutoId()
            //save the message in Firebase
            let interval = NSDate().timeIntervalSince1970
            userReference.updateChildValues(["/postPics/": profileImageURL, "/posts/": "none", "/profilePics/": profilePic, "/name/": nameyname as Any, "/timestamp/": interval])
            //userReference.updateChildValues(["posts": profileImageURL])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toPostPage") {
            let vc = segue.destination as! PostPageViewController
            vc.pagePostPics = postPics
            vc.pagePosts = posts
            vc.pageProfilePics = profilePic
            vc.thestampp = timestampzz
        }
    }
}
