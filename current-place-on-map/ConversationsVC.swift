//
//  MessagesViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 1/14/18.
//  Copyright © 2018 William French. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox
import UserNotifications
import NVActivityIndicatorView

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties


    @IBOutlet weak var notificationsPage: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
//    lazy var leftButton: UIBarButtonItem = {
//        let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
//        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ConversationsVC.showProfile))
//        return button
//    }()
    lazy var rightButton: UIBarButtonItem = {
        let icon = UIImage.init(named: "compose")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(ConversationsVC.showContacts))
        return button
    }()
    var items = [Conversation]()
    var selectedUser: User?
    
    
    let alert = UIAlertController(title: nil, message: "Messages loading. Please wait...", preferredStyle: .alert)
    
    let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 26), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    //MARK: Methods
    func customization()  {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        // notification setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        //right bar button
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white;
        self.navigationItem.rightBarButtonItem = self.rightButton
        //left bar button image fetching
        //self.navigationItem.leftBarButtonItem = self.leftButton
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                let contentSize = CGSize.init(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                path.lineWidth = 2
                UIColor.white.setStroke()
                path.stroke()
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    //weakSelf?.leftButton.image = finalImage
                    weakSelf = nil
                }
            })
        }
    }
    
    //Downloads conversations
    func fetchData() {
        
        self.alert.view.addSubview(self.loadingIndicator)
        self.present(self.alert, animated: true, completion: nil)
        
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.playSound()
                        break
                    }
                }
            }
           
            
        }
        
        self.alert.dismiss(animated: false, completion: nil)
        self.loadingIndicator.stopAnimating()
        
    }
    
    //Shows profile extra view
    @objc func showProfile() {
        let info = ["viewType" : ShowExtraView.profile]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
        self.inputView?.isHidden = true
    }
    
    //Shows contacts extra view
    @objc func showContacts() {
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }
    
    //Show EmailVerification on the bottom
//    @objc func showEmailAlert() {
//        User.checkUserVerification {[weak weakSelf = self] (status) in
//            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
//            UIView.animate(withDuration: 0.3) {
//                weakSelf?.view.layoutIfNeeded()
//                weakSelf = nil
//            }
//        }
//    }
    
    //Shows Chat viewcontroller with given user
    @objc func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    func playSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
        if (segue.identifier == "toNotificationPerm") {
            let childViewController = segue.destination as! NotificationsPermissionsViewController
            childViewController.navigationController?.navigationItem.hidesBackButton = true
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
        if(segue.identifier == "backAgainz"){
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 1
                tabVC.navigationItem.hidesBackButton = true;
                tabVC.navigationController?.isNavigationBarHidden = true
            }
        }
        
        
    }
    
    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            print ("THIS IS EMPTY!!!")
            self.alert.dismiss(animated: false, completion: nil)
            self.loadingIndicator.stopAnimating()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            cell.nameLabel.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.messageLabel.text = message
            case .location:
                cell.messageLabel.text = "Location"
            default:
                cell.messageLabel.text = "Media"
            }
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
                cell.messageLabel.textColor = GlobalVariables.purple
            }
           self.alert.dismiss(animated: false, completion: nil)
            return cell
            
        }
        
    }

    
    var isLoadingTableView = true
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.items.count > 0 && isLoadingTableView {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows, let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                isLoadingTableView = false
                //do something after table is done loading
                self.alert.dismiss(animated: false, completion: nil)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    

    
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        
        
        
        
        
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadingIndicator.startAnimating();
        
        
        
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
            
            
           
            
            
        }
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                print ("FIND OUT!!")
                
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "toNotificationPerm", sender: self)
                }
            }
            
            if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                DispatchQueue.main.async(execute: {
                    print ("mother fucker")
                    self.performSegue(withIdentifier: "toOpenNotificationz", sender: self)
                })
            }
            
            if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                DispatchQueue.main.async(execute: {
                    print ("chyea boi!!")
                    self.fetchData()
                })
            }
        })
        //self.showEmailAlert()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //testForNotifications()
        
        
    }
    
    func testForNotifications() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                print ("FIND OUT!!")
                
                DispatchQueue.main.async() {
                    self.performSegue(withIdentifier: "toNotificationPerm", sender: self)
                }
            }
            
            if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                DispatchQueue.main.async(execute: {
                    print ("mother fucker")
                    self.performSegue(withIdentifier: "toOpenNotificationz", sender: self)
                })
            }
            
            if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                DispatchQueue.main.async(execute: {
                    print ("chyea boi!!")
                })
            }
        })
    }
}






