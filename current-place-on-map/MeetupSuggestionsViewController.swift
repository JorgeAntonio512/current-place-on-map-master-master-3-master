//
//  MeetingsSuggestionsViewController.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 11/18/17.
//  Copyright © 2017 William French. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Firebase
import NVActivityIndicatorView

class MeetupSuggestionsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView : WKWebView!
    @IBOutlet var containzView: UIView? = nil
    
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50), type: NVActivityIndicatorType(rawValue: 26), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Austin Tall Community"
        
        let FirebaseMessageRef1 = Database.database().reference().child("webpages/SurveyMonkeySurvey")
        //Write value from Firebase database to the label:
        FirebaseMessageRef1.observe(.value) { (snap: DataSnapshot) in
            let webpage = snap.value as! String
            
            let myURL = URL(string: webpage)
            guard let url = URL(string: webpage) else { return }
            self.webView = WKWebView(frame: self.view.frame)
            self.webView.translatesAutoresizingMaskIntoConstraints = false
            self.webView.isUserInteractionEnabled = true
            self.webView.navigationDelegate = self
            self.view.addSubview(self.webView)
            let request = URLRequest(url: url)
            self.webView.load(request)
            
            // add activity
            self.loadingIndicator.startAnimating();
            
            self.alert.view.addSubview(self.loadingIndicator)
            self.present(self.alert, animated: true, completion: nil)
            
            
            self.webView.navigationDelegate = self
            
        }}
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismiss(animated: false, completion: nil)
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: false, completion: nil)
        loadingIndicator.stopAnimating()
    }
    
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
