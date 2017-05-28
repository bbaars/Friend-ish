//
//  SegmentedControl.swift
//  Friend-ish_V1
//
//  Created by Brandon Baars on 5/2/17.
//  Copyright © 2017 Brandon Baars. All rights reserved.
//

import UIKit

/* By inheriting from UIControl, it allows us to modify it on the story board */
@IBDesignable class SegmentedControl: UIControl {
    
    private var _labels = [UILabel]()
    var thumbView = UIView()
    
    var items:[String] = ["Facebook", "Twitter", "Instagram"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func setupView() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        setupLabels()
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        
        for label in _labels {
            label.removeFromSuperview()
            
        }
        
        _labels.removeAll(keepingCapacity: true)
        
        for item in 1...items.count {
            let label = UILabel(frame: CGRect.zero)
            label.text = items[item - 1]
            label.textAlignment = .center
            label.textColor = UIColor(white: 0.5, alpha: 1.0)
            self.addSubview(label)
            _labels.append(label)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = selectedFrame.width / CGFloat(items.count)
        selectedFrame.size.width = newWidth
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.white
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(_labels.count)
        
        for index in 0..._labels.count - 1 {
            var label = _labels[index]
            let xPos = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPos, y: 0, width: labelWidth, height: labelHeight)
        }
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        
        for(index, item) in _labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    
    
    func displayNewSelectedIndex() {
        var label = _labels[selectedIndex]
        
        self.thumbView.frame = label.frame
        
    }
}
