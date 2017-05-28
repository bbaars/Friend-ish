//
//  WalkthroughViewController.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/8/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper
import TwitterKit

class WalkthroughViewController: UIViewController, UIViewControllerTransitioningDelegate {

    // IBOutlets for the walk through screens
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var socialMediaIconImage: UIImageView!
    @IBOutlet weak var annotationButton: UIButton!
    
    let transition = CircularTransition()
    
    // MARK: - Data Model for the walkthrough screens
    var index = 0
    var headerText = ""
    var imageName = ""
    var iconImage = ""
    
    // stores the users information
    var headerLabels = ["", "", "", ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        headerLabel.text = headerText
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        socialMediaIconImage.image = UIImage(named: iconImage)
        
        // Started Button Customization
        nextButton.isHidden = (index == 3) ? true: false
        facebookButton.isHidden = (index == 0) ? false : true
        facebookButton.isEnabled = (index == 0) ? true : false
        twitterButton.isHidden = (index == 1) ? false : true
        twitterButton.isEnabled = (index == 1) ? true : false
        instagramButton.isHidden = (index == 2) ? false : true
        instagramButton.isEnabled = (index == 2) ? true : false
        startButton.isHidden = (index == 3) ? false : true
        startButton.isEnabled = (index == 3) ? true : false
        annotationButton.isHidden = (index == 3) ? false : true
        
        annotationButton.layer.cornerRadius = 5.0
        annotationButton.layer.borderWidth = 2.0
        annotationButton.layer.borderColor = UIColor.white.cgColor

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapController = segue.destination as! UINavigationController
        mapController.transitioningDelegate = self
        mapController.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.circleColor = annotationButton.backgroundColor!
        transition.startingPoint = annotationButton.center
        
        return transition
    }
    
    /*
     * This function gets called when the next button (skip) has been tapped
     */
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.goToNextPageVC()
    }

    /*
     * This function gets called when the start button is tapped
     */
    @IBAction func startButtonTapped(_ sender: Any) {
        
        let user = UserDefaults.standard
        user.set(true, forKey: "DisplayedWalkThrough")
        
        for (key, value) in currentUser {
            DataService.ds.REF_USER_CURRENT.child(key).setValue(value)
            print("\(key), \(value)")
        }
        
        if currentUser["isFacebook"] as? Bool == false && currentUser["isTwitter"] as? Bool == false && currentUser["isInstagram"] as? Bool == false {
            
            
        } else {
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        
        
        
    }
    
    /*
     * This function handles the sign-in/authentication of facebook, if the user chooses
     */
    @IBAction func facebookButtonTapped(_ sender: Any) {
       
        let facebookLogin = FBSDKLoginManager()
        
        let deviceScale = Int(UIScreen.main.scale)
        let width = 100 * deviceScale
        let height = 100 * deviceScale
        
        facebookLogin.logIn(withReadPermissions: ["public_profile", "user_friends", "user_status"], from: self) { (result, error) in
            if error != nil {
                print("There was an error due to - \(String(describing: error))")
            } else if (result?.isCancelled)! {
                print("BRANDON: User cancelled the facebook login")
            } else {
                print("BRANDON: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                /* Once the user accepts the permissions, it pulls their data done to update labels / photos */
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.width(\(width)).height(\(height)), friends"]).start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        self.headerLabel.text = "Oops, something went wrong!"
                        print("Brandon: \(String(describing: error))")
                    } else {
     
                        if let fbDetails = result as? Dictionary<String, Any> {
                        
                            /* Obtaines the users Facebook Name */
                            if let name = fbDetails["name"] as? String {
                                self.headerLabels[self.index] = "Welcome, \(name)"
                                self.headerLabel.text = "\(self.headerLabels[self.index])"
                                currentUser["fbName"] = name
                            }
                            
                            /* Obtaines the current users unique facebook ID */
                            if let userID = fbDetails["id"] as? String {
                                currentUser["facebookID"] = userID
                            }
                            
                            /* obtains their profile photo as a URL of type String */
                            if let picture = fbDetails["picture"] as? [String: AnyObject] {
                                if let data = picture["data"] as? [String: AnyObject] {
                                    if let url = data["url"] as? String {
                                        currentUser["fbProfilePhoto"] = url
                                    }
                                }
                            }
                            
                            /* obtain the users friend list (only those who have authorized this app) :( */
                            if let friends = fbDetails["friends"] as? [String : AnyObject] {
                                var friendList = [[String: String]]()
                                //print("BRANDONS FRIENDS: \(friends)")
                                if let data = friends["data"] as? [AnyObject] {
                                    for i in 0..<data.count {
                                        let userDict = data[i] as? [String: String]
                                        friendList.append([(userDict?["id"])! : (userDict?["name"])!])
                                    }
                                    
                                    currentUser["fbFriendsList"] = friendList
                                }
                            }
                        }
                        
                        
                    }
                    self.firebaseAuth(credential)
                    
                    /* sets the authentication of facebook to true */
                    currentUser["isFacebook"] = true
                    
                    self.goToNextPageVC()
                })
                
            }
        }
    }
    
    /*
     * This function handles the sign-in/authentication of twitter
     */
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
        print("twitter button tapped")
       
        Twitter.sharedInstance().logIn { (session, error) in
            if error != nil {
                
            } else {
                print("Signed in as \(String(describing: session?.userName))")
                if let name = session?.userName {
                    self.headerLabels[self.index] = "Welcome, \(name)"
                    self.headerLabel.text = "\(self.headerLabels[self.index])"
                }
                let credential = FIRTwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                self.firebaseAuth(credential)
                currentUser["isTwitter"] = true
                self.updateTwitterFollowers((session?.userName)!)
                self.goToNextPageVC()
            }
        }
    }
    
    /*
     * Handles the instagram authentication
     */
    @IBAction func instagramButtonTapped(_ sender: Any) {
        // Handle at a later date.
        
        self.goToNextPageVC()

    }
    
    
    /*
     *
     *
     */
    func firebaseAuth(_ newCredential: FIRAuthCredential) {
        
        if currentUser["isFacebook"] as? Bool == true || currentUser["isTwitter"] as? Bool == true {
        
            FIRAuth.auth()?.currentUser?.link(with: newCredential, completion: { (user, error) in
                if error != nil {
                    print("BRANDON: Unable to authenticate with Firebase due to - \(String(describing: error))")
                } else {
                    print("BRANDON: Successfully authenticated with Firebase")
                
                if let user = user {
                    let userData = ["provider": newCredential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    print("BRANDON: Successfully added multiple accounts with Firebase")
                }
                }
            })
        } else {
            
            FIRAuth.auth()?.signIn(with: newCredential, completion: { (user, error) in
                if error != nil {
                    print("BRANDON: Unable to authenticate with Firebase due to - \(String(describing: error))")
                } else {
                    print("BRANDON: Successfully authenticated with Firebase")
                    
                    if let user = user {
                        let userData = ["provider": newCredential.provider]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            })
        }
    }

    
    /*
    *
    *
    */
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        
        DataService.ds.createFirebaseUser(uid: id, userData: userData)
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
    }
    
    func goToNextPageVC () {
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index)
    }
}
