//
//  RoundedCornersButton.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/9/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 7.0 {
        didSet {
            setUpView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView () {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
