//
//  DismissKeyboard.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/10/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /* 
     * This function creates a UITapGestureRecognizer for when the user wants to dismiss the
     * on screen keyboard. They tap anywhere on the screen and it will dismiss.
     *
     * Call on the viewDidLoad() function for your UITextField
     */
    func hideKeyboardWhenTappedOutsideTextField () {
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
    }
    
    /*
    * Dismisses the keyboard on screen
    */
    func dismissKeyboard () {
        view.endEditing(true)
    }
}

extension UITextField {
    
    /*
     * This function makes the return key on the keyboard say "done"
     *
     * Use with "textFieldShouldReturn() to end the editing when the return (done) button is pressed
     */
    func returnKeyboardType() {
        self.returnKeyType = UIReturnKeyType.done
    }
}
