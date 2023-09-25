//
//  SwiftScrollView.swift
//  SwiftScrollView
//
//  Created by Rajamohan S, Independent Software Developer on 30/11/18.
//  Copyright (c) 2018 Rajamohan S. All rights reserved.
//
//  See https://rajamohan-s.github.io/ for author information.
//

import UIKit

/**
 * https://github.com/RAJAMOHAN-S/SwiftScrollViews
 */
open class SwiftScrollView:UIScrollView,TextComponentDelegate{
    

    @IBOutlet public var swiftScrollViewsDelegate:SwiftScrollViewsDelegate?
    
    private var textComponents = [UIView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addNotifications()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegateTextComponents(in: self, textComponents: &textComponents)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.shouldReturn(for: textField, with: self.swiftScrollViewsDelegate)
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return self.shouldBegin(textField)
    }
    
    /**
     * PERFECTHAN : delaysContentTouches 적용을 위한 처리
     * https://stackoverflow.com/questions/17701323/uiscrollview-delayscontenttouches-issue
     */
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true;
    }
}
