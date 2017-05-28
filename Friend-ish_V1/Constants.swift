//
//  Constants.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/12/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import Firebase


let KEY_UID: String = "uid"
var currentUser = ["fbName" : "",
                   "twitName" : "",
                   "facebookID" : "",
                   "isFacebook" : false,
                   "isTwitter" : false,
                   "isInstagram" : false,
                   "fbProfilePhoto" : "",
                   "twitProfilePhoto" : "",
                   "fbFriendsList" : [[String: String]]()] as [String : Any]

var selectedUser = ["fbName" : "",
                    "twitName" : "",
                    "facebookID" : "",
                    "isFacebook" : false,
                    "isTwitter" : false,
                    "isInstagram" : false,
                    "fbProfilePhoto" : "",
                    "twitProfilePhoto" : "",
                    "fbFriendsList" : [[String: String]]()] as [String : Any]

var MAP_RADIUS:Double = 10
