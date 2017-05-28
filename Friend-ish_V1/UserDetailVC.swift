//
//  UserDetailVC.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 5/2/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

class UserDetailVC: UIViewController {


    @IBOutlet weak var segmentedController: UnderlinedSegmentedController!
    @IBOutlet weak var profilePicture: RoundImage!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pictureView =  UIImageView()
    
    var userDetailDict = ["fbName" : "",
                        "twitName" : "",
                        "facebookID" : "",
                        "isFacebook" : false,
                        "isTwitter" : false,
                        "isInstagram" : false,
                        "fbProfilePhoto" : "",
                        "twitProfilePhoto" : "",
                        "fbFriendsList" : [[String: String]]()] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.viewSetup()
        
    }
    
    /*
     * Sets up the inital view controller
     */
    private func viewSetup () {
        segmentedController.selectedSegmentIndex = 0
        
        let attr = NSDictionary(object: UIFont(name: "Avenir", size: 36.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
        
        segmentedController.addUnderlineForSelectedSegment()
        
        profilePicture.image = userDetailDict["fbProfilePhoto"] as? UIImage
        nameLabel.text = userDetailDict["fbName"] as? String
        
        
        
        // IF THE USER ISN"T LOGGED ON WITH FACEBOOK
        if userDetailDict["isFacebook"] as? Bool != nil || currentUser["isFacebook"] as? Bool != nil {
            segmentedController.setEnabled(false, forSegmentAt: 0)
            segmentedController.selectedSegmentIndex = 1
            
            // IF THEY"RE NOT LOGGED ON WITH TWITTER EITHER
            if userDetailDict["isTwitter"] as? Bool != nil || currentUser["isTwitter"] as? Bool != nil{
                segmentedController.selectedSegmentIndex = 2
                
            }
        }
        
        // IF THEY"RE NOT LOGGED ON WITH TWITTER
        if userDetailDict["isTwitter"] as? Bool != nil || currentUser["isTwitter"] as? Bool != nil {
            segmentedController.setEnabled(false, forSegmentAt: 1)
        }
        
        //IF THEYRE NOT LOGGED ON INSTAGRAM
        if userDetailDict["isInstagram"] as? Bool != nil || currentUser["isInstagram"] as? Bool != nil {
            segmentedController.setEnabled(false, forSegmentAt: 2)
        }
    }

    @IBAction func segmentedControlDidChange(_ sender: Any) {
        
        segmentedController.changeUnderlinePosition()
        
    }
    
    @IBAction func backButtonPushed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
