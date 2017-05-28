//
//  UserHandler.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/20/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import Firebase

protocol LocationController: class {
    
    func updateUsersLocation(lat: Double, long: Double)
}

class UserHandler {
    
    private static let _instance = UserHandler()
    
    weak var delegate: UserHandler?
    
    static var instance: UserHandler {
        return _instance
    }    
}
