//
//  MainViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

var welcome: Bool = true

var name: String = "Andrew"

var prevIdx: Int = 0
var goBack: Bool = false

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
    var entryMessage: String = "Main menu"

    if goBack {
      if welcome {
        entryMessage = "Hello, \(name)!"
        welcome = false
      }
      else {
        entryMessage = ""
      }
      menu = MenuList(mainItemList, message: entryMessage, idx: prevIdx)
      goBack = false
    } else {
      if welcome {
        entryMessage = "Hello, \(name)!"
        welcome = false
      }
      menu = MenuList(mainItemList, message: entryMessage)
    }
    
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
    speak("Main menu")
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
      delegate?.transitionTo(viewId: "profileViewController", options: "")
    }
    else if currentItemId == "exercise"{
      delegate?.transitionTo(viewId: "exerciseViewController", options: "")
    }
    else if currentItemId == "bluetooth"{
      delegate?.transitionTo(viewId: "bluetoothViewController", options: "")
//      print("transition bluetooth")
    }
    else if currentItemId == "settings"{
      delegate?.transitionTo(viewId: "settingsViewController", options: "")
    }
    else if currentItemId == "help"{
      delegate?.transitionTo(viewId: "helpViewController", options: "")
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
