//
//  DataService.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/11/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

/* This creates a reference to our root storage of our database */
let DB_BASE = FIRDatabase.database().reference()

/* This creates a reference to our root storage of our database */
let DB_STORAGE = FIRStorage.storage().reference()

class DataService {
    
    /* Singleton for our app to access (global reference) */
    static let ds = DataService()
 
    private var _REF_BASE = DB_BASE
    
    /* Database References */
    private var _REF_USERS = DB_BASE.child("users")
    
    /* Storage Reference */
    private var _REF_PROFILE_PIC = DB_STORAGE.child("profile-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let user = REF_USERS.child(USER_UID)
        return user
    }
    
    var USER_UID: String {
        let UID = KeychainWrapper.standard.string(forKey: KEY_UID)
        return UID!
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_PROFILE_IMG: FIRStorageReference {
        return _REF_PROFILE_PIC
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, Any>) {
        
        /* updates the value of the child */
        _REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
