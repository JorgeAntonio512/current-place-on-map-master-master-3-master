//
//  LoginViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 11/20/17.
//  Copyright © 2017 William French. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //IBOutlets:
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var CustomFacebookLb: UIButton!
    @IBOutlet weak var RegisterLB: UIButton!
    @IBOutlet weak var LoginLB: UIButton!
    
    //Colors:
    let FBColor = UIColor(red: 60/255, green: 90/255, blue: 150/255, alpha: 1)
    let FBColorLight = UIColor(red: 73/255, green: 109/255, blue: 182/255, alpha: 1)
    let linkColor = UIColor(red: 34/255, green: 133/255, blue: 251/255, alpha: 1).cgColor
    let linkColorLight = UIColor(red: 205/255, green: 228/255, blue: 254/255, alpha: 1).cgColor
    

    
    
    //lets:
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Screnn Height:\(screenHeight)")
        //STYLE
        CustomFacebookLb.layer.cornerRadius = 5
        CustomFacebookLb.backgroundColor = FBColor
        RegisterLB.layer.borderWidth = 1
        RegisterLB.layer.cornerRadius = 5
        RegisterLB.layer.borderColor = linkColor
        self.hideKeyboard()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    //Orientation change:
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape && self.screenHeight < 1366.0 {
            print("Landscape")
        } else {
            print("Portrait")
            print("screenHeight: \(self.screenHeight)")
            UIView.animate(withDuration: 0.5, animations: {
                self.textfieldTouched()
            })
        }
    }
    
    //Log out of Facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    
    //Log in with Facebook
    @IBAction func FBloginCustomBT(_ sender: Any) {
        activityIndicator.startAnimating()
        handleCustomFBLogin()
        CustomFacebookLb.backgroundColor = FBColor
    }


     @IBAction func CustomFacebookDown(_ sender: Any) {
        CustomFacebookLb.backgroundColor = FBColorLight
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:")
                return
            }
            self.showEmailAddress()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        print("invalid email")
                        self.showErrorAlert(title: "Could not sign in with Facebook :(", msg: "\(error!.localizedDescription)")
                    case .emailAlreadyInUse:
                        print("in use")
                        self.showErrorAlert(title: "Could not sign in with Facebook :(", msg: "The email address is already in use by another account. Please try to sign in with Email and Password instead or tap on 'Forgot Password' if you don't remeber your password.")
                    default:
                        print("Create User Error: \(error!)")
                        self.showErrorAlert(title: "Could not sign in with Facebook", msg: "\(error!.localizedDescription)")
                    }
                }
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
            self.CompleteSignIn(id: user!.uid)
            let keyChain = DataService().keyChain
            //Print user id from (User's device local storage):
            if keyChain.get("uid") != nil {
                let FirebaseUid = keyChain.get("uid")
                print("KEYCHAIN USER id: \(FirebaseUid!)")
                //set up firebase references:
                let FirebaseMessageRef = Database.database().reference().child("users/\(FirebaseUid!)")
                
                
                FirebaseMessageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.hasChild("height"){
                        self.performSegue(withIdentifier: "HasProfile", sender: nil)
                        print("height exist!")
                        
                    }else{
                        self.performSegue(withIdentifier: "SignIn", sender: nil)
                        print("height doesn't exist :(")
                    }
                    
                    
                })
            }
           // self.performSegue(withIdentifier: "SignIn", sender: nil)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    
    
    //if user is already loged in before, we'll jump login screen and show next app page
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = DataService().keyChain
        //Print user id from (User's device local storage):
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            //set up firebase references:
            let FirebaseMessageRef = Database.database().reference().child("users/\(FirebaseUid!)")
            
            
            FirebaseMessageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("height"){
                    self.performSegue(withIdentifier: "HasProfile", sender: nil)
                    print("height exist!")
                    
                }else{
                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                    print("height doesn't exist :(")
                }
                
                
            })
        }
        
        
        activityIndicator.stopAnimating()
        
        //DEVICE ORIENTATION:
        var viewDidLoadOrientation = "PORTRAIT"
        // Screen Sizes:
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        print("\(orientation)")
        //print("- ScreenWidth: \(screenWidth), screenHeight: \(screenHeight)")
        
        if screenHeight < screenWidth {
            viewDidLoadOrientation = "LANDSCAPE"
            print("Orientation: \(viewDidLoadOrientation)")
        } else {
            viewDidLoadOrientation = "PORTRAIT"
            print("Orientation: \(viewDidLoadOrientation)")
        }
        
    }
    
    
    
  
        
    //Save temporal data on user's device:
    func CompleteSignIn(id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
    }
    var iCloudKeyStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore()
    
    
    // Register new user with Email/Password
        @IBAction func Register(_ sender: Any) {
        
        RegisterLB.layer.borderColor = linkColor
        activityIndicator.startAnimating()
                        //Creating UIAlertController and
                        //Setting title and message for the alert dialog
                        let alertController = UIAlertController(title: "Email & password confirmation", message: "Please re-enter your email and password", preferredStyle: .alert)
                        
                        //the confirm action taking the inputs
                        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                            
                            //getting the input values from user
                            let email = alertController.textFields?[0].text
                            let password = alertController.textFields?[1].text
                            
                            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
                            if email == self.emailField.text
                            {if password == self.passwordField.text
                            {
                                if let email = self.emailField.text, let password = self.passwordField.text {
                                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                                        if error != nil {
                                            print(error!)
                                            print("ERROR: Register error description:\(error!.localizedDescription)")
                                            if let errCode = AuthErrorCode(rawValue: error!._code) {
                                                switch errCode {
                                                case .invalidEmail:
                                                    print("invalid email")
                                                    self.showErrorAlert(title: "Could not register :(", msg: "\(error!.localizedDescription)")
                                                case .emailAlreadyInUse:
                                                    print("in use")
                                                    self.showErrorAlert(title: "Could not register :(", msg: "The email address is already in use by another account. Please try to sign in with Facebook instead.")
                                                default:
                                                    print("Create User Error: \(error!)")
                                                    self.showErrorAlert(title: "Could not register :(", msg: "\(error!.localizedDescription)")
                                                }
                                            }
                                            
                                        }
                                
                                        else {
                                // if no errors log the user in and allow access to next page
                                            self.CompleteSignIn(id: (user?.user.uid)!)
                                self.performSegue(withIdentifier: "SignIn", sender: nil)
                                //Save the password and the email.
                                        self.iCloudKeyStore.set(password, forKey: email)}
                                    } }}
                            else {let alertController = UIAlertController(title: "Passwords do not match", message: "please make your passwords match!", preferredStyle: .alert)
                                
                                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (_) in }
                                
                                alertController.addAction(dismissAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                                print("password does not match")}
                            }
                            else {
                                
                                let alertController = UIAlertController(title: "Email addresses do not match", message: "please make your email addresses match!", preferredStyle: .alert)
                                
                                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (_) in }
                                
                                alertController.addAction(dismissAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                
                                
                                
                                print("email address does not match")}
                        }
                        
                        //the cancel action doing nothing
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                        
                        //adding textfields to our dialog box
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Enter Email"
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Enter Password"
                        }
                        
                        //adding the action to dialogbox
                        alertController.addAction(confirmAction)
                        alertController.addAction(cancelAction)
                        
                        //finally presenting the dialog box
                        self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                    
                    
                    
                    
                   
                }

   
    @IBAction func RegisterDown(_ sender: Any) {
        RegisterLB.layer.borderColor = linkColorLight
    }
    
    
    
    //Sign in with Email/Password
    @IBAction func Login(_ sender: Any) {
        LoginLB.layer.borderColor = linkColor
        activityIndicator.startAnimating()
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    if user != nil{
                        print("ERROR: User already exist")
                       // self.linkAccountWihtFacebook()
                        print(user?.user.uid)
                    } else {
                        print(error!)
                        print("ERROR: Register error description:\(error!.localizedDescription)")
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .invalidEmail:
                                print("invalid email")
                                self.showErrorAlert(title: "Could not sign in :(", msg: "\(error!.localizedDescription)")
                            case .wrongPassword:
                                print("Wrong Password")
                                self.showErrorAlert(title: "Could not sign in :(", msg: "\(error!.localizedDescription) Please try to sign in with Facebook instead or tap on 'Forgot Password' if you don't remember your password.")
                            case .emailAlreadyInUse:
                                print("in use")
                                self.showErrorAlert(title: "Could not sign in :(", msg: "The email address is already in use by another account. Please try to sign in with Facebook instead or tap on 'Forgot Password' if you don't remember your password.")
                            default:
                                print("Create User Error: \(error!)")
                                self.showErrorAlert(title: "Could not sign in :(", msg: "\(error!.localizedDescription)")
                            }
                        }
                    }
                    
                } else {
                    self.CompleteSignIn(id: (user?.user.uid)!)
                    
                    let keyChain = DataService().keyChain
                    //Print user id from (User's device local storage):
                    if keyChain.get("uid") != nil {
                        let FirebaseUid = keyChain.get("uid")
                        print("KEYCHAIN USER id: \(FirebaseUid!)")
                        //set up firebase references:
                        let FirebaseMessageRef = Database.database().reference().child("users/\(FirebaseUid!)")
                        
                        
                        FirebaseMessageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if snapshot.hasChild("height"){
                                self.performSegue(withIdentifier: "HasProfile", sender: nil)
                                print("height exist!")
                                
                            }else{
                                self.performSegue(withIdentifier: "SignIn", sender: nil)
                                print("height doesn't exist :(")
                            }
                            
                            
                        })
                    }
                    //self.performSegue(withIdentifier: "SignIn", sender: nil)
                }
            }
        }
    }
    @IBAction func loginButtonDown(_ sender: Any) {
        LoginLB.layer.borderColor = linkColorLight
    }
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: stopActivityIndicator)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func stopActivityIndicator(action: UIAlertAction) {
        activityIndicator.stopAnimating()
    }
    
    
    //Forgot your Password
    @IBAction func didRequestPasswordReset(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Password Reset", message: "Please enter your email address:", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.text = self.emailField.text
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send my new password", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0] // Force unwrapping because we know it exists.
            if let unwrappedEmail = email?.text {
                print("\(unwrappedEmail)")
                Auth.auth().sendPasswordReset(withEmail: unwrappedEmail) { error in
                    if let error = error {
                        // An error happened.
                        if email == nil {
                            print("Please enter your email")
                        } else {
                            print("\(unwrappedEmail)")
                            print("\(error.localizedDescription)")
                            self.showErrorAlert(title: "Could not send the new password :(", msg: "Please enter a valid email address")
                        }
                    } else {
                        // Password reset email sent.
                        print("Email sent")
                    }
                }
            }
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func termsAndConditions(_ sender: Any) {
        
    }
    
    func textfieldTouched() {
        UIView.animate(withDuration: 0.5, animations: {
        })
    }
    
    @IBAction func emailFieldTouched(_ sender: Any) {
        print("Email field pressed")
        textfieldTouched()
    }
    @IBAction func passwordFieldTouched(_ sender: Any) {
        print("Password field pressed")
        textfieldTouched()
    }
    
    
    
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
