//
//  FlipDismissAnimationViewController.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 5/6/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

class FlipDismissAnimationViewController: NSObject, UIViewControllerAnimatedTransitioning {

    
    var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        /*
         * 1. Animation shrinks the view, we need to flip the initial and final frames
         */
        _ = transitionContext.initialFrame(for: fromVC)
        let finalFrame = destinationFrame
        
        
        /*
         * 2. Manipulation the "From" view to take a snapshot of it
         */
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        snapshot?.layer.cornerRadius = 6.0
        snapshot?.layer.masksToBounds = true
        
        /*
         * 3. Add the "TO" view and the snapshot to the container view, then hide the "from" view so it doesn't
         *    conflict with the snapshot
         */
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        fromVC.view.isHidden = false
        
        AnimationHelper.perspectiveTransformForContainerView(containerView: containerView)
        
        /*
         * 4. Hide the "TO" view with a rotation technique.
         */
        toVC.view.layer.transform = AnimationHelper.yRotation(angle: -Double.pi / 2)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .calculationModeCubic, animations: { 
            
            /*
             * 1. scale the view first, then hide the snapshot with rotation. Reveal the "TO" view by rotation it
             *    halfway around the y-axis in the opposite direction
             */
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: { 
                snapshot?.frame = finalFrame
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { 
                snapshot?.layer.transform = AnimationHelper.yRotation(angle: Double.pi / 2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: { 
                toVC.view.layer.transform = AnimationHelper.yRotation(angle: 0.0)
            })
            
            
        }, completion: { _ in
            
            /*
             * 2. Remove the snapshot and inform the context that the transition is complete. This
             *    allows UIKit to update the view controller hierarchy and tidy up the views.
             */
            fromVC.view.isHidden = false
            snapshot?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


















