//  sessionViewController.swift
//  Hey Coacher
//
//  Created by Prakhar Lunia on 6/1/17.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation

class sessionViewController: CustomUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleSwipeLeft(){
        print("Heart Rate")
    }
    override func handleSwipeRight(){
        print("Cadence")
    }
    override func handleTapLeft(){
        print("Distance")
    }
    override func handleTapRight(){
        print("Speed")
    }
}
