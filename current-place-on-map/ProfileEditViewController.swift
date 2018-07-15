//
//  ProfileEditViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/6/18.
//  Copyright © 2018 William French. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import KeychainSwift
import FBSDKLoginKit
import McPicker
import NVActivityIndicatorView

class ProfileEditViewController: UITableViewController {

   
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UIButton!
    @IBOutlet weak var height: UIButton!
    @IBOutlet weak var status: UIButton!
    @IBOutlet weak var your: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profilePicCell: UITableViewCell!
    
    @IBOutlet weak var relCell: UITableViewCell!
    
    @IBOutlet weak var saveCell: UITableViewCell!
    @IBOutlet weak var bioCell: UITableViewCell!
    @IBOutlet weak var zipCell: UITableViewCell!
    @IBOutlet weak var heightCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var genderCell: UITableViewCell!
    @IBOutlet weak var picCell: UIView!
    @IBOutlet weak var editPic: UITextView!
    
    var selectedProfilePhoto: UIImage?
    
     let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 32), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    override func viewDidAppear(_ animated: Bool) {
        picCell.bringSubview(toFront: editPic)
        
        //Print user id from (User's device local storage):
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("users/\(FirebaseUid!)/gender")
            let FirebaseMessageRefHeight = Database.database().reference().child("users/\(FirebaseUid!)/height")
            let FirebaseMessageRefName = Database.database().reference().child("users/\(FirebaseUid!)/name")
            let FirebaseMessageRefZip = Database.database().reference().child("users/\(FirebaseUid!)/city")
            let FirebaseMessageRefAbout = Database.database().reference().child("users/\(FirebaseUid!)/about")
            let FirebaseMessageRefStatus = Database.database().reference().child("users/\(FirebaseUid!)/status")
            //Write value from Firebase database to the label:
            FirebaseMessageRefHeight.observe(.value) { (snap: DataSnapshot) in
                self.height.setTitle((snap.value as AnyObject).description, for: .normal)
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRef.observe(.value) { (snap: DataSnapshot) in
                self.gender.setTitle((snap.value as AnyObject).description, for: .normal)
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRefName.observe(.value) { (snap: DataSnapshot) in
                self.name.text = (snap.value as AnyObject).description
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRefZip.observe(.value) { (snap: DataSnapshot) in
                self.city.text = (snap.value as AnyObject).description
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRefAbout.observe(.value) { (snap: DataSnapshot) in
                self.your.text = (snap.value as AnyObject).description
            }
            //Write value from Firebase database to the label:
            FirebaseMessageRefStatus.observe(.value) { (snap: DataSnapshot) in
                self.status.setTitle((snap.value as AnyObject).description, for: .normal)
            }
            
            
            
            
            
            
            
            
        }
        // add a tap gesture to the profile image for users to pick their avatar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Handle the User Profile Picking
    @objc func handleProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func writeHeightInFirebase(height: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRefHeight = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRefHeight.updateChildValues(["/users/\(FirebaseUid!)/height": height])
        }
    }
    
    func writeStatusInFirebase(status: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRef.updateChildValues(["/users/\(FirebaseUid!)/status": status])
        }
    }
    
    func writeCityInFirebase(city: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRefCity = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRefCity.updateChildValues(["/users/\(FirebaseUid!)/city": city])
        }
    }
    
    func writeNameInFirebase(name: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRefName = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRefName.updateChildValues(["/users/\(FirebaseUid!)/name": name])
        }
    }
    
    func writeAboutInFirebase(about: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRef.updateChildValues(["/users/\(FirebaseUid!)/about": about])
        }
    }
    
    func writeFeelingInFirebase(gender: String) {
        //Select the correct user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference()
            //save the message in Firebase
            FirebaseMessageRef.updateChildValues(["/users/\(FirebaseUid!)/gender": gender])
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
        self.hideKeyboard()
        
        
        
        let toplineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView.layer.borderWidth = 1.0
        toplineView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameCell.addSubview(toplineView)
        
        
        let toplineView1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView1.layer.borderWidth = 1.0
        toplineView1.layer.borderColor = UIColor.lightGray.cgColor
        self.genderCell.addSubview(toplineView1)
        
        let toplineView2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView2.layer.borderWidth = 1.0
        toplineView2.layer.borderColor = UIColor.lightGray.cgColor
        self.heightCell.addSubview(toplineView2)
        
        let toplineView3 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView3.layer.borderWidth = 1.0
        toplineView3.layer.borderColor = UIColor.lightGray.cgColor
        self.relCell.addSubview(toplineView3)
        
        
        let toplineView4 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView4.layer.borderWidth = 1.0
        toplineView4.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCell.addSubview(toplineView4)
        
        let toplineView5 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView5.layer.borderWidth = 1.0
        toplineView5.layer.borderColor = UIColor.lightGray.cgColor
        self.bioCell.addSubview(toplineView5)
        
        let toplineView6 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1.0))
        toplineView6.layer.borderWidth = 1.0
        toplineView6.layer.borderColor = UIColor.lightGray.cgColor
        self.saveCell.addSubview(toplineView6)
        
        
        
        
        let bottomlineView = UIView(frame: CGRect(x: 0, y: self.nameCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView.layer.borderWidth = 1.0
        bottomlineView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameCell.addSubview(bottomlineView)
        
        
        let bottomlineView2 = UIView(frame: CGRect(x: 0, y: self.heightCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView2.layer.borderWidth = 1.0
        bottomlineView2.layer.borderColor = UIColor.lightGray.cgColor
        self.heightCell.addSubview(bottomlineView2)
        
        let bottomlineView3 = UIView(frame: CGRect(x: 0, y: self.relCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView3.layer.borderWidth = 1.0
        bottomlineView3.layer.borderColor = UIColor.lightGray.cgColor
        self.relCell.addSubview(bottomlineView3)
        
        
        let bottomlineView4 = UIView(frame: CGRect(x: 0, y: self.zipCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView4.layer.borderWidth = 1.0
        bottomlineView4.layer.borderColor = UIColor.lightGray.cgColor
        self.zipCell.addSubview(bottomlineView4)
        
        
        let bottomlineView5 = UIView(frame: CGRect(x: 0, y: self.bioCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView5.layer.borderWidth = 1.0
        bottomlineView5.layer.borderColor = UIColor.lightGray.cgColor
        self.bioCell.addSubview(bottomlineView5)
        
        let bottomlineView6 = UIView(frame: CGRect(x: 0, y: self.saveCell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1.0))
        bottomlineView6.layer.borderWidth = 1.0
        bottomlineView6.layer.borderColor = UIColor.lightGray.cgColor
        self.saveCell.addSubview(bottomlineView6)
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            let uid = FirebaseUid
            
            
            self.loadingIndicator.startAnimating();
            
            self.profileImageView.addSubview(self.loadingIndicator)
            self.loadingIndicator.center = CGPoint(x: self.profilePicCell.contentView.bounds.size.width/2,y: self.profilePicCell.contentView.bounds.size.height/2)
            
            
            
            let FirebaseMessageRef6 = Database.database().reference().child("users/\(FirebaseUid!)/profileImageURL")
            // get a reference to our file store
            FirebaseMessageRef6.observe(.value) { (snap: DataSnapshot) in
                let profilePic = (snap.value as AnyObject).description
                
                
                
                
            // get a reference to our file store
            let islandRef = Storage.storage().reference(forURL: profilePic!)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pick = UIImage(data: data!)
                self.profileImageView.image = pick
                self.loadingIndicator.stopAnimating()
                self.profileImageView.layer.borderWidth = 1
                self.profileImageView.layer.masksToBounds = false
                self.profileImageView.layer.borderColor = UIColor.black.cgColor
                self.profileImageView.frame = CGRect(x: 20, y: 20, width: 110, height: 110)
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
                self.profileImageView.clipsToBounds = true
                self.profileImageView.center = CGPoint(x: self.profilePicCell.contentView.bounds.size.width/2,y: self.profilePicCell.contentView.bounds.size.height/2)
                self.editPic.center = CGPoint(x: self.profilePicCell.contentView.bounds.size.width/2, y: self.profilePicCell.bounds.size.height-9)
                
                }}}
    }
    
    
    @IBAction func genderpressed(_ sender: Any) {
        
        McPicker.show(data: [["Female", "Male"]]) {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.gender.setTitle(name, for: .normal)
            }
        }}
    
    
    @IBAction func heightpressed(_ sender: Any) {
        
        
            
            McPicker.show(data: [
                ["4 feet", "5 feet", "6 feet", "7 feet"],
                ["0 inches", "1 inches", "2 inches", "3 inches", "4 inches", "5 inches", "6 inches", "7 inches", "8 inches", "9 inches", "10 inches", "11 inches"]
            ]) {  (selections: [Int : String]) -> Void in
                if let prefix = selections[0], let name = selections[1] {
                    self.height.setTitle("\(prefix) \(name)", for: .normal)
                }}}
    
    

    @IBAction func statusPressed(_ sender: Any) {
        
        McPicker.show(data: [["single", "dating someone", "engaged/married"]]) {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
            self.status.setTitle(name, for: .normal)
            }
        }}

    
    
    @IBAction func onwards(_ sender: Any) {
        if gender.currentTitle == "Button" {
            let alertController = UIAlertController(title: "Gender not selected!", message:
                "Please select your gender!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            if height.currentTitle == "Button" {
                let alertController = UIAlertController(title: "Height not selected!", message:
                    "Please choose your height!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                if name.text?.isEmpty ?? true {
                    let alertController = UIAlertController(title: "Name not input!", message:
                        "Please input your name!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    if city.text?.isEmpty ?? true {
                        let alertController = UIAlertController(title: "Zip code not input!", message:
                            "Please input your zip code!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    } else {
                        if your.text?.isEmpty ?? true {
                            let alertController = UIAlertController(title: "You haven't said anything about yourself!", message:
                                "Please say something about yourself!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        } else {
                            if status.currentTitle == "Button" {
                                let alertController = UIAlertController(title: "You haven't choosen a relationship status!", message:
                                    "Please choose a relationship status!", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else {
                                
                                if let profileImage = self.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.5) {let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                                    
                                    let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 26), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                                    loadingIndicator.startAnimating();
                                    
                                    alert.view.addSubview(loadingIndicator)
                                    present(alert, animated: true, completion: nil)
                                    AuthService.signUp(imageData: imageData, onSuccess: {
                                    let string1 = self.height.currentTitle!
                                    let string2 = string1.replacingOccurrences(of: "\\", with: "")
                                    self.writeHeightInFirebase(height: string2)
                                    self.writeFeelingInFirebase(gender: self.gender.currentTitle!)
                                    self.writeCityInFirebase(city: self.city.text!)
                                    self.writeNameInFirebase(name: self.name.text!)
                                    self.writeAboutInFirebase(about: self.your.text!)
                                    self.writeStatusInFirebase(status: self.status.currentTitle!)
                                    
                                        self.dismiss(animated: false, completion: nil)
                                        loadingIndicator.stopAnimating()
                                        
                                        self.navigationController?.popViewController(animated: true)
                                }, onError:{ _ in })
                                }
                                else {
                                    let alertController = UIAlertController(title: "Please choose a profile image!", message:
                                        "Your profile image can not be empty. Tap it to set it.", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
// MARK: - ImagePicker Delegate Methods

            
            
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
            selectedProfilePhoto = image
        }
        
        dismiss(animated: true)
    }
}
