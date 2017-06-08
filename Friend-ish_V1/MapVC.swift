//
//  MapVC.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/8/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

private let flipPresentAnimationController = FlipPresentationAnimationController()
private let flipDismissAnimationController = FlipDismissAnimationViewController()

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /* IB OUTLETS FOR MAP VC */
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var popUpView: RoundedUIView!
    @IBOutlet weak var userLocationButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var popUpName: UILabel!
    @IBOutlet weak var popUpImage: RoundImage!
    
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var twitterIcon: UIImageView!
    @IBOutlet weak var instagramIcon: UIImageView!
    
    /* VARIABLES */
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var user = [String:Any]()
    var userAnnotations = [String : MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        /* Enables the map to follow the user */
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        locationManager.delegate = self
        
        
        /* References the "users_location" in the Firebase Database 
         *
         * The database is set up to where the users location is stored
         * by their UID. That is used to reference the user
         */
        geoFireRef = DataService.ds.REF_BASE.child("users_location")
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        self.popUpView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayWalkThrough()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        locationAuthStatus()
        self.showUsersOnMap()
    }
    
    func sideMenus() {
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 200
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func showUsersOnMap() {
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:mapView.centerCoordinate.longitude)
    
        let circleQuery = geoFire!.query(at: location, withRadius: 50)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                
                 print("USER KEY: \(key)")
                
                var user = [String:Any]()
                
                DataService.ds.REF_USERS.child("\(key)").observe(.value, with: { (snapshot) in
                    
                    if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        user = [:]
                        
                        for snap in snapshot {
                            user["\(snap.key)"] = snap.value
                            print(snap)
                        }
                        
                        if key != DataService.ds.USER_UID && self.userAnnotations[key] == nil {
                            
                            let cord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            
                            self.addUserAnnotation(cord, fbName: user["fbName"] as! String, twitName: user["twitName"] as! String, facebookID: user["facebookID"] as! String, isFacebook: user["isFacebook"] as! Bool, isTwitter: user["isTwitter"] as! Bool, isInstagram: user["isInstagram"] as! Bool, fbProfilePhoto: user["fbProfilePhoto"] as! String, twitProfilePhoto: user["twitProfilePhoto"] as! String, fbFriendsList: user["fbFriendsList"] as! [[String : String]], key)
                            self.observeCoordinateChange(key)
                        } else {
                            
                            print("Couldn't Find Anyone else around you :( ")
                        }
                    }
                })
            }
        })
    }
    
    private func observeCoordinateChange(_ key: String) {
        
        DataService.ds.REF_BASE.child("users_location").child(key).observe(.value, with: { (snapshot) in
            
            self.geoFire.getLocationForKey(key, withCallback: { (location, error) in
                
                if error != nil {
                    print("error due to \(String(describing: error))")
                } else {
                    
                    self.userAnnotations[key]!.coordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                }
             })
        })
    }
    
    
    private func addUserAnnotation(_ coordinate: CLLocationCoordinate2D,fbName: String, twitName: String, facebookID: String, isFacebook: Bool, isTwitter: Bool, isInstagram: Bool, fbProfilePhoto: String, twitProfilePhoto: String, fbFriendsList: [[String:String]] , _ uid: String) {
        

        let anno = UserAnnotation(fbName: fbName, twitName: twitName, facebookID: facebookID, isFacebook: isFacebook, isTwitter: isTwitter, isInstagram: isInstagram, fbProfilePhoto: fbProfilePhoto, twitProfilePhoto: twitProfilePhoto, fbFriendsList: fbFriendsList)
        anno.coordinate = coordinate
        anno.title = fbName
        userAnnotations[uid] = anno
        self.mapView.addAnnotation(anno)
    }
    

    func displayWalkThrough() {
        
        let userDefault = UserDefaults.standard
        let displayedWalkThrough = userDefault.bool(forKey: "DisplayedWalkThrough")
        
        if !displayedWalkThrough {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") {
                self.present(pageViewController, animated: true, completion: nil)
            }
        } else {
            self.showUsersOnMap()
        }
        
        self.sideMenus()
        
    }
    
    func showGeoFireUsers() {
        self.showUsersOnMap()
    }
    
    func locationAuthStatus () {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            let _ = MKUserLocation().location
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        
        
    }
    
    
    func centerMapOnLocation() {
        
         self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    // calls everytime the user updates location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            self.setGeoFireLocation(personLocation: loc, UsersUID: DataService.ds.USER_UID)
            
            if !mapHasCenteredOnce {
                centerMapOnLocation()
                mapHasCenteredOnce = true
            }
            
        }
    }
    
    // Resizes and alters the annotation
    func resizeImage(image: UIImage) -> UIImage {
        
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    func roundImage(image: UIImage) -> UIImageView {
       
        let radius: CGFloat = 25
        let bWidth: CGFloat = 1.0
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = image
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = bWidth
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        return imageView
    }
    
    func addShadow(view: MKAnnotationView) -> MKAnnotationView {
        
        let offset: CGFloat = 3.0
        let opacity: Float = 0.65
        let radius: CGFloat = 3.0
        
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset.height = offset
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "user"
        var annotationView: MKAnnotationView?
        
        let userURL = NSURL(string: currentUser["fbProfilePhoto"] as! String)
        let userImgData = NSData(contentsOf: userURL! as URL)
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "me")
            
            if let imageData = userImgData {
                let userProfileImage = UIImage(data: imageData as Data)
                
                let resizedImage = self.resizeImage(image: userProfileImage!)
                let imageView = self.roundImage(image: resizedImage)
                let view = self.addShadow(view: annotationView!)
                
                view.addSubview(imageView)
                view.frame = imageView.frame

            } else {
                annotationView?.image = UIImage(named: "profile")
            }
            
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
            
        } else {
            
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
           
            if let anno = annotation as? UserAnnotation {
                let url = NSURL(string: anno.fbProfilePhoto)! as URL
                let imgData = NSData(contentsOf: url)
                
                if let imageData = imgData {
                    
                    let userProfileImage = UIImage(data: imageData as Data)
                    let imageView = self.roundImage(image: userProfileImage!)
                    let aView = self.addShadow(view: av)
                    
                    aView.addSubview(imageView)
                    aView.frame = imageView.frame
                    
                } else {
                    av.image = UIImage(named: "profile")
                }
                
                av.canShowCallout = true
                let btn = UIButton()
                btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                btn.setImage(UIImage(named: "rocket-ship"), for: .normal)
                av.rightCalloutAccessoryView = btn
            }
            
            annotationView = av
        }
        return annotationView
    }
    
    /*
     * This function gets called when the user taps on the callout that appeared
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? UserAnnotation {
        
            self.popUpView.isHidden = false
            popUpName.text = anno.title
            self.resetCard()
            
            let url = NSURL(string: anno.fbProfilePhoto)! as URL
            let imgData = NSData(contentsOf: url)
            
            if let imageData = imgData {
                let userProfileImage = UIImage(data: imageData as Data)
                let imageView: UIImageView = UIImageView(image: userProfileImage!)
                popUpImage.image = imageView.image
                selectedUser["fbProfilePhoto"] = imageView.image
            }
            
            if !anno.isFacebook {
                facebookIcon.alpha = 0.20
            }
            
            if !anno.isTwitter {
                twitterIcon.alpha = 0.20
            }
            
            if !anno.isInstagram {
                instagramIcon.alpha = 0.20
            }
            
            selectedUser["fbName"] = anno.fbName
            selectedUser["twitName"] = anno.twitName
            selectedUser["facebookID"] = anno.facebookID
            selectedUser["isTwitter"] = anno.isTwitter
            selectedUser["isFacebook"] = anno.isFacebook
            selectedUser["isInstagram"] = anno.isInstagram
            selectedUser["fbFriendsList"] = anno.fbFriendsList
            
            
            
        }
    }
    
    func setGeoFireLocation(personLocation loc: CLLocation, UsersUID uid: String) {
        
        geoFire.setLocation(loc, forKey: "\(uid)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "userDetailVC" {
            if let userDetail = segue.destination as? UserDetailVC {
                if let user = sender as? [String:Any] {
                    userDetail.userDetailDict = user
                    userDetail.transitioningDelegate = self
                }
            }
        }
    }
    
    @IBAction func mutualFriendsButtonPushed(_ sender: Any) {
    
        performSegue(withIdentifier: "userDetailVC", sender: selectedUser)
        
    }
    
    
    
    
    @IBAction func userLocationButtonPushed(_ sender: Any) {
        self.centerMapOnLocation()
    }
    
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let xFromCenter = card.center.x - view.center.x
        let rotationAngle = xFromCenter/view.frame.width * 0.61
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        let scale = min(100/abs(xFromCenter) , 1)
        let stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        card.transform = stretchAndRotation
        card.center = sender.location(in: view)
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 100 {
                // Thumbs Down
                // Move off to the left
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 100)
                    card.alpha = 0
                })
                return
            } else if card.center.x > view.frame.width - 100 {
                // Thumbs Up
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 100)
                    card.alpha = 0
                })
                return
            }
            
            self.resetCard()
        }
    }

    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.popUpView.alpha = 1
            self.popUpView.transform = .identity
            self.popUpView.center = self.view.center
            self.facebookIcon.alpha = 1
            self.twitterIcon.alpha = 1
            self.instagramIcon.alpha = 1
        })
    }

}

extension MapVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        flipPresentAnimationController.originFrame = popUpView.frame
        
        return flipPresentAnimationController
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        flipDismissAnimationController.destinationFrame = mapView.frame
//        
//        return flipDismissAnimationController
//        
//    }
}

