//
//  AuthService.swift
//  current-place-on-map
//
//  Created by George Pazdral (work) on 12/17/17.
//  Copyright © 2017 William French. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase


class AuthService {
    

    
    
    static func signUp(imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        // create a Firebase user
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
       
            
            let uid = FirebaseUid
            
            // get a reference to our file store
            let storeRef = Storage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storeRef.putData(imageData, metadata: metadata, completion: { (metaData, error) in
                if error != nil {
                    print("Profile Image Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                // if there's no error
                // get the URL of the profile image in the file store
                //let profileImageURL = metaData?.downloadURL()?.absoluteString
                storeRef.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                    } else {
                        // Get the download URL for 'images/stars.jpg'
                        let pathURL = url?.absoluteString
                        //let pathString = pathURL?.path
                        self.setUserInformation(profileImageURL: pathURL!, onSuccess: onSuccess)
                    }
                }
                // set the user information with the profile image URL
                
            })
            
        }
    }
    

    
    
    // MARK: - Firebase Saving Methods
    
    static func setUserInformation(profileImageURL: String, onSuccess: @escaping () -> Void) {
        // create the new user in the user node and store username, email, and profile image URL
        
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            let FirebaseUid = keyChain.get("uid")
            print("KEYCHAIN USER id: \(FirebaseUid!)")
            
            
            let uid = FirebaseUid
            
        let ref = Database.database().reference()
        let userReference = ref.child("users")
            let newUserReference = userReference.child(uid!)
        newUserReference.updateChildValues(["profileImageURL": profileImageURL])
        onSuccess()
    }
    
}
}
