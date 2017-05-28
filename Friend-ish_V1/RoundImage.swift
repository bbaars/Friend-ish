//
//  RoundImage.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 4/18/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImage: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setUpView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
