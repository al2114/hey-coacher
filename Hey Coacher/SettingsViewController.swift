//
//  SettingsViewController.swift
//  Hey Coacher
//
//  Created by Prakhar Lunia on 6/1/17.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

class SettingsViewController: CustomUIViewController {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var prevLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
 
    var menu: MenuList?

    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsItemList = [MenuItem("Connect Remote", "connectremote"),
                            MenuItem("Scan for Sensors", "scansensor")]
        
        menu = MenuList(settingsItemList)
        updateLabels()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleSwipeLeft(){
        menu?.iterNext()
        self.updateLabels()
    }
    override func handleSwipeRight(){
        menu?.iterPrevious()
        self.updateLabels()
    }
    override func handleTapLeft(){
        delegate?.transitionTo(viewId: "mainViewController", options: "")
    }
    override func handleTapRight(){
        let currentItemId: String = (menu?.currentId())!
        
        if currentItemId == "connectremote"{
            delegate?.transitionTo(viewId: "connectRemoteViewController", options: "")
        }
    
    }
    
    func updateLabels(){
        mainLabel.text = menu?.currentItem;
        prevLabel.text = menu?.previousItem
        nextLabel.text = menu?.nextItem;
    }

}
