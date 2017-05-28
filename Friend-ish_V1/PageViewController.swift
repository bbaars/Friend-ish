//
//  PageViewController.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/8/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var pageHeaders = ["Login With Facebook", "Login With Twitter", "Login With Instagram", "Got it?!"]
    var pageImages = ["app1", "app2", "app3", "app4"]
    var buttonImages = ["f", "twitter", "instagram", "rocket-ship"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.dataSource = self
        
        if let startWalkthroughVC = self.viewControllerAtIndex(0) {
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK - Navigation for the view controller
    func nextPageWithIndex(_ index: Int) {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index + 1) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
        
        
       
    }
    
    func viewControllerAtIndex(_ index: Int) -> WalkthroughViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.pageImages.count {
            return nil
        }
        
        if let walkthroughVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            walkthroughVC.imageName = pageImages[index]
            walkthroughVC.headerText = pageHeaders[index]
            walkthroughVC.index = index
            walkthroughVC.iconImage = buttonImages[index]
                    
            return walkthroughVC
        }
        
        return nil
    }
    

}

extension PageViewController: UIPageViewControllerDataSource {
    
    // returns the page controller before the one you're currently at
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    
    //return the page controller for the next view
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
}















