//
//  SlideOutMenuVC.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/16/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

class SlideOutMenuVC: UIViewController {

    @IBOutlet weak var userProfilePhoto: RoundImage!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        self.loadProfilePhoto()
       
    }
    
    func loadProfilePhoto() {
        
        let url = NSURL(string: currentUser["fbProfilePhoto"] as! String)! as URL
        let imgData = NSData(contentsOf: url)
        
        if let imageData = imgData {
            
            let userPhoto = UIImage(data: imageData as Data)
            userProfilePhoto.image = userPhoto
        }
    }
}
