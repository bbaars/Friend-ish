//
//  SegueInFromLeft.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 5/6/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

class SegueInFromLeft: UIStoryboardSegue {

    override func perform() {
        
        let src: UIViewController = self.source
        let dst: UIViewController = self.destination
        
        let transition: CATransition = CATransition()
        let timeFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        
        transition.duration = 0.5
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        src.view.window?.layer.add(transition, forKey: kCATransition)
        src.present(dst, animated: false, completion: nil)
    }
}
