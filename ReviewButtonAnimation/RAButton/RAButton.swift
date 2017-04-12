//
//  RAButton.swift
//  ReviewButtonAnimation
//
//  Created by Apple on 05/04/17.
//  Copyright © 2017 Joyce. All rights reserved.
//

import UIKit

protocol RABProtocol {
    func didSelectItemAtIndex(index: Int)
}

open class RAButton: UIView {
    
    var config = RAConfiguration.shared
    var rabDelegate: RABProtocol?
    var selectedIndex = -1
    var frameOfSelectedIndex = CGRect()
    public var currentState = RAConfiguration.RABState.normal {
        didSet {
            if self.currentState == RAConfiguration.RABState.normal {
                self.backgroundColor = self.normalColor
            } else if self.currentState == RAConfiguration.RABState.expanded {
                self.backgroundColor = self.expandedColor
            } else if self.currentState == RAConfiguration.RABState.selected {
                self.backgroundColor = self.selectedColor
            }
        }
    }
    
    public var title = "HOW WAS YOUR EXPERIENCE?" {
        didSet {
        }
    }
    
    public var titleColor = RAConfiguration.shared.textColor {
        didSet {
            RAConfiguration.shared.textColor = titleColor
        }
    }
    
    public var titleFont = RAConfiguration.shared.textFont {
        didSet {
            RAConfiguration.shared.textFont = titleFont
        }
    }
    
    public var normalCornerRadius: CGFloat = RAConfiguration.shared.defaultCornerRadius {
        didSet {
            if self.currentState != RAConfiguration.RABState.expanded {
                self.layer.cornerRadius = self.normalCornerRadius
            }
            self.config.defaultCornerRadius = self.normalCornerRadius
        }
    }
    
    public var expandedCornerRadius: CGFloat = RAConfiguration.shared.expandedCornerRadius {
        didSet {
            if self.currentState == RAConfiguration.RABState.expanded {
                self.layer.cornerRadius = self.expandedCornerRadius
            }
            self.config.expandedCornerRadius = self.expandedCornerRadius
        }
    }
    
    public var normalColor: UIColor = RAConfiguration.shared.normalBackgroundColor {
        didSet {
            if self.currentState == RAConfiguration.RABState.normal {
                self.backgroundColor = self.normalColor
            }
            self.config.normalBackgroundColor = self.normalColor
        }
    }
    
    public var expandedColor: UIColor = RAConfiguration.shared.expandedBackgroundColor {
        didSet {
            if self.currentState == RAConfiguration.RABState.expanded {
                self.backgroundColor = self.expandedColor
            }
            self.config.expandedBackgroundColor = self.expandedColor
        }
    }
    

    public var selectedColor: UIColor = RAConfiguration.shared.selectedBackgroundColor {
        didSet {
            if self.currentState == RAConfiguration.RABState.selected {
                self.backgroundColor = self.selectedColor
            }
            self.config.selectedBackgroundColor = self.selectedColor
        }
    }
    
    public var reviewImages = [UIImage]()
    public var reviewDescriptions = [String]()

    lazy var selectedOptionView: UIImageView = {
       
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.backgroundColor = .clear
        i.clipsToBounds = true
        return i
    }()
    
    lazy var titleView:UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
        v.text = self.title
        v.font = self.titleFont
        v.textColor = self.titleColor
        v.textAlignment = .center
        return v
    }()
    
    lazy var imagesView:UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        
        let stackView   = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        let spacing = self.bounds.size.width / CGFloat(self.reviewImages.count + 1) / 2.0
        stackView.spacing   = spacing < 15.0 ? spacing : 15.0
        
        var tag = 1
        for i in self.reviewImages {
            let imageView = UIButton(type: .custom)
            imageView.tag = tag
            tag += 1
            imageView.setImage(i, for: UIControlState())
            imageView.backgroundColor = .clear
            imageView.addTarget(self, action: #selector(self.selectedOption), for: .touchUpInside)
            stackView.addArrangedSubview(imageView)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(stackView)
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true

        return v
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(frame: CGRect,
                         title: String = "HOW WAS YOUR EXPERIENCE?" ,
                         images: [UIImage],
                         descriptions: [String],
                         normalCornerRadius: CGFloat = RAConfiguration.shared.defaultCornerRadius ,
                         expandedCornerRadius: CGFloat = RAConfiguration.shared.expandedCornerRadius,
                         normalColor: UIColor = RAConfiguration.shared.normalBackgroundColor,
                         expandedColor: UIColor = RAConfiguration.shared.expandedBackgroundColor,
                         selectedColor: UIColor = RAConfiguration.shared.selectedBackgroundColor,
                         expandedHeight: CGFloat = RAConfiguration.shared.expandedHeight) {
        
        super.init(frame: frame)
        /// defer statement: defer executes as the last part of the current scope
        /// similar to throw-finally block - executes no matter what but as the last one in priority
        defer {
            self.normalCornerRadius = normalCornerRadius
            self.title = title
            self.reviewImages = images
            self.reviewDescriptions = descriptions
            self.config.defaultHeight = frame.size.height
            self.expandedCornerRadius = expandedCornerRadius
            self.normalColor = normalColor
            self.expandedColor = expandedColor
            self.selectedColor = selectedColor
            self.config.expandedHeight = expandedHeight
            self.configureViews()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        self.titleView.frame = self.bounds
        self.titleView.backgroundColor = .clear
        self.titleView.clipsToBounds = true
        self.addSubview(self.titleView)
        
        self.selectedOptionView.frame = CGRect(x: 20, y: 0.5 * (self.config.defaultHeight - 30.0), width: 30.0, height: 30.0)
        self.selectedOptionView.image = UIImage()
        self.addSubview(self.selectedOptionView)
        
        self.imagesView.frame = CGRect(x: 0, y: self.titleView.frame.maxY - 10, width: self.frame.size.width, height: self.config.expandedHeight - self.config.defaultHeight)
        self.imagesView.backgroundColor = .clear
        self.imagesView.clipsToBounds = true
        self.imagesView.alpha = 0.0
        self.addSubview(self.imagesView)
        
        let t = UITapGestureRecognizer(target: self, action: #selector(self.expandMe))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(t)
    }
    
    func expandMe() {
        
        if self.currentState == RAConfiguration.RABState.normal || self.currentState == RAConfiguration.RABState.selected {
            let amount: CGFloat = 0.4, duration: TimeInterval = 0.6, delay: TimeInterval = 0
            var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
            ds = amount / 3
            self.frame.size.height = self.config.expandedHeight
            self.layer.cornerRadius = self.expandedCornerRadius
            self.backgroundColor = self.config.expandedBackgroundColor
            self.alpha = 0.0
            self.imagesView.alpha = 0.0

            UIView.animateKeyframes(
                withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                        self.alpha = 1.0
                        let t = CGAffineTransform(translationX: dx, y: dy)
                        self.transform = t.scaledBy(x: 1 + ds, y: 1 + ds)
                        self.titleView.text = self.title
                        self.selectedOptionView.frame = CGRect(x: 20, y: 0.5 * (self.config.defaultHeight - 30.0), width: 30.0, height: 30.0)
                        self.selectedOptionView.image = UIImage()
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.18, relativeDuration: 0.28, animations: {
                        let t = CGAffineTransform(translationX: dx, y: dy)
                        self.imagesView.alpha = 1.0
                        self.imagesView.transform = t.scaledBy(x: amount, y: amount)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
                        self.transform = .identity
                        self.imagesView.transform = .identity
                    }
            }, completion: { finished in
                self.currentState = RAConfiguration.RABState.expanded
            })
        }
    }
    
    func selectedOption(sender: UIButton) {
        self.selectedIndex = sender.tag
        frameOfSelectedIndex = sender.frame
        shrinkMe()
    }
    
    func shrinkMe() {
        self.alpha = 0.0
        self.selectedOptionView.image = self.reviewImages[self.selectedIndex - 1]
        self.selectedOptionView.frame = self.frameOfSelectedIndex

        let amount: CGFloat = 0.4, duration: TimeInterval = 0.6, delay: TimeInterval = 0
        var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
        ds = amount / 3
        
        UIView.animateKeyframes(
            withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                    self.alpha = 1.0
                    self.frame.size.height = self.config.defaultHeight
                    self.layer.cornerRadius = self.config.defaultCornerRadius
                    self.backgroundColor = self.config.selectedBackgroundColor
                    self.selectedOptionView.frame = CGRect(x: 20, y: 0.5 * (self.config.defaultHeight - 30.0), width: 30.0, height: 30.0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.03, relativeDuration: 0.2, animations: { 
                    let t = CGAffineTransform(translationX: dx, y: dy)
                    self.transform = t.scaledBy(x: 1 + ds, y: 1 + ds)
                    self.titleView.text = self.reviewDescriptions[self.selectedIndex - 1]
                })
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.28, animations: {
                    let t = CGAffineTransform(translationX: dx, y: dy)
                    self.imagesView.alpha = 0.0
                    self.imagesView.transform = t.scaledBy(x: amount, y: amount)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
                    self.transform = .identity
                    self.imagesView.transform = .identity
                }
        }, completion: { finish in
            self.currentState = RAConfiguration.RABState.selected
            if let delegate = self.rabDelegate {
                delegate.didSelectItemAtIndex(index: self.selectedIndex)
            }
        })
    }
}
