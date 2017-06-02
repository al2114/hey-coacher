//
//  MainViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

var welcome: Bool = true

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
    var entryMessage: String = ""
    
    if welcome {
      entryMessage = "Hello, \(name)!"
      welcome = false
    }

    menu = MenuList(mainItemList, message: entryMessage) 	

    updateLabels()
    
  }

  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }

  
  override func handleSwipeLeft(){
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    
    menu?.iterNext()
    self.updateLabels()
  }
  override func handleSwipeRight(){
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    menu?.iterPrevious()
    self.updateLabels()
  }
  override func handleTapLeft(){
//    delegate?.transitionTo(viewId: menu?.parent)
    
  }
  override func handleTapRight(){
    
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "profile"{
      delegate?.transitionTo(viewId: "profileViewController")
    }
    else if currentItemId == "exercise"{
      delegate?.transitionTo(viewId: "exerciseViewController")
    }
    else if currentItemId == "bluetooth"{
      print("transition bluetooth")
    }
    else if currentItemId == "settings"{
      print("transition setting")
    }
    else if currentItemId == "help"{
      print("transition help")
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
