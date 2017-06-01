//
//  MainViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

class MainViewController: CustomUIViewController {
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  
  var menu: MenuList?

  override func viewDidLoad() {
      super.viewDidLoad()

    let mainItemList = [MenuItem("Switch Profile", "profile"),
                        MenuItem("Exercise", "exercise"),
                        MenuItem("Connect Devices", "bluetooth"),
                        MenuItem("Settings", "settings"),
                        MenuItem("Help","help")]
    let name = "Andrew"
    let entryMessage = "Welcome back, \(name)!"
    
    menu = MenuList(mainItemList, message: entryMessage)
    updateLabels()
    
  }

  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
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
//    delegate?.transitionTo(viewId: menu?.parent)
    
  }
  override func handleTapRight(){
    
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "profile"{
      delegate?.transitionTo(viewId: "profileViewController")
    }
    
    
  }
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
