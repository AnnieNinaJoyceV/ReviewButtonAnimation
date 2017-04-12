//
//  ViewController.swift
//  ReviewButtonAnimation
//
//  Created by Apple on 05/04/17.
//  Copyright © 2017 Joyce. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RABProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = RAButton.init(frame: CGRect(x: 50, y: 150, width: 300, height: 50), images: [UIImage(named: "001")!, UIImage(named: "002")!, UIImage(named: "003")!, UIImage(named: "004")!, UIImage(named: "005")!], descriptions: ["Loved it!", "Liked it!", "Nothing special", "You let us down.", "Very disappointed"])
        view.rabDelegate = self
        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK-RABProtocol
    func didSelectItemAtIndex(index: Int) {
        print(index)
    }
}

