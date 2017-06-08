//
//  FirebaseDatabaseHandler.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/13/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import Firebase
extension AppDelegate {
    
    func loadUserDataFromFirebase() {
        
        //var userId = FIRAuth.auth()?.currentUser?.uid
        
        DataService.ds.REF_USER_CURRENT.observe(.value, with: { (snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    currentUser["\(snap.key)"] = snap.value
                }
            }
        })
    }
}
