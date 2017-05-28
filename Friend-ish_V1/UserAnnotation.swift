//
//  UserAnnotation.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/11/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class UserAnnotation: MKPointAnnotation {


    /* the name of the user, by default facebooks name */
    var fbName: String

    /* the name of the twitter user */
    var twitName: String

    /* each facebook user has a unique ID, this is needed to access their profile info */
    var facebookID: String

    /* bool to store whether logged in with facebook */
    var isFacebook: Bool

    /* bool to store whether they're logged in with Twitter */
    var isTwitter: Bool

    /* bool to store wheter they're logged in with Instagram */
    var isInstagram: Bool

    /* the facebook profile photo in URL format. FACEBOOK API returns URL */
    var fbProfilePhoto: String

    /* Twitter profile photo, if user doesn't login with facebook */
    var twitProfilePhoto: String

    /* An array of users Facebook friends */
    var fbFriendsList: [[String:String]]

    init (fbName: String, twitName: String, facebookID: String, isFacebook: Bool, isTwitter: Bool, isInstagram: Bool, fbProfilePhoto: String, twitProfilePhoto: String, fbFriendsList: [[String:String]]) {

        self.fbName = fbName
        self.twitName = twitName
        self.facebookID = facebookID
        self.isFacebook = isFacebook
        self.isTwitter = isTwitter
        self.isInstagram = isInstagram
        self.fbProfilePhoto = fbProfilePhoto
        self.twitProfilePhoto = twitProfilePhoto
        self.fbFriendsList = fbFriendsList
    }
}
