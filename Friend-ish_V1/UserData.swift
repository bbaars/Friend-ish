//
//  UserData.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/11/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import FirebaseDatabase

/* 
 * This class handles the stored data of the user
 *
 */
class UserData {
    
    /* the name of the user, by default facebooks name */
    private var _fbName: String
    
    /* the name of the twitter user */
    private var _twitName: String
    
    /* each facebook user has a unique ID, this is needed to access their profile info */
    private var _facebookID: String
    
    /* bool to store whether logged in with facebook */
    private var _isFacebook: Bool
    
    /* bool to store whether they're logged in with Twitter */
    private var _isTwitter: Bool
    
    /* bool to store wheter they're logged in with Instagram */
    private var _isInstagram: Bool
    
    /* the facebook profile photo in URL format. FACEBOOK API returns URL */
    private var _fbProfilePhoto: String
    
    /* Twitter profile photo, if user doesn't login with facebook */
    private var _twitProfilePhoto: String
    
    /* An array of users Facebook friends */
    private var _fbFriendsList: [[String:String]]
    
    
    /* Getters and setters for the user 
     * At any point, they can always sign in or out of the social media, thus
     * needing the bool of each to possibly change. They will also be allowed to
     * change their "display name & display photo"
     */
    var fbFriendsList: [[String:String]] {
        get {
            return _fbFriendsList
        } set {
            self.fbFriendsList = newValue
        }
    }
    
    var fbName: String {
        get {
            return _fbName
        }
    }
    
    var facebookID: String {
        get {
            return _facebookID

        }
    }
    
    var isFacebook: Bool {
        get {
            return _isFacebook
        } set {
            self._isFacebook = newValue
        }
    }
    
    var isTwitter: Bool {
        get {
            return _isTwitter
        } set {
            self._isTwitter = newValue
        }
    }
    
    var isInstagram: Bool {
        get {
            return _isInstagram
        } set {
           self._isInstagram = newValue
        }
    }
    
    var twitName: String {
        get {
            return _twitName
        }
    }
    
    var fbProfilePhoto: String {
        get {
            return _fbProfilePhoto
        }
    }
    
    
    /*
     * Initializer for the user
     */
    init(userDict: [String: Any]) {
        
        self._fbName = userDict["fbName"] as! String
        self._twitName = userDict["twitName"] as! String
        self._facebookID = userDict["facebookID"] as! String
        self._isFacebook = userDict["isFacebook"] as! Bool
        self._isTwitter = userDict["isTwitter"] as! Bool
        self._isInstagram = userDict["isInstagram"]  as! Bool
        self._fbProfilePhoto = userDict["fbProfilePhoto"] as! String
        self._twitProfilePhoto = userDict["twitProfilePhoto"] as! String
        self._fbFriendsList = userDict["fbFriendsList"] as! [[String:String]]
    }

    
    /*
     * This function takes in two users and returns the mutual friends they share with 
     * each other on [Facebook, twitter, instagram]
     * Twitter looks at mutual following (If they both are following the same user)
     * Instagram looks at mutual following (If they both are following the same user)
     *
     * @params  Current User: UserData  The current user of the application
     *          Request User: UserData  The user with which they would like to know mutual friends
     *
     * @Return  mutualFriendsArray: Array<Int>   3 Integers with Number of Mutual Friends/Followers (Friends, Twitter, Instagram) In that Order
     */
    func returnNumberOfMutualFriend(currentUser: UserData, requestedUser: UserData) -> Array<Int> {
        
        var mutualFriendsArray = [0, 0, 0]
        
        
        
        return mutualFriendsArray
    }
    
    
}
