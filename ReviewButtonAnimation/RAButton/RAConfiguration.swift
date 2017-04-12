//
//  RAConfiguration.swift
//  ReviewButtonAnimation
//
//  Created by Apple on 05/04/17.
//  Copyright © 2017 Joyce. All rights reserved.
//

import UIKit

public struct RAConfiguration {
    
    //MARK:- Initializers
    public init() { } //empty
    public static var shared = RAConfiguration()
    
    public enum RABState {
        case normal, expanded, selected
    }
    
    public var normalBackgroundColor: UIColor = UIColor(red: 232.0/255.0, green: 128.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    public var expandedBackgroundColor: UIColor = UIColor(red: 232.0/255.0, green: 110.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    public var selectedBackgroundColor: UIColor = UIColor(red: 230.0/255.0, green: 102.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var textColor: UIColor = UIColor(red: 241.0/255.0, green: 240.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    
    public var defaultHeight: CGFloat = 50.0
    public var expandedHeight: CGFloat = 90.0
    public var defaultCornerRadius: CGFloat = 25.0
    public var expandedCornerRadius: CGFloat = 0.5
}
