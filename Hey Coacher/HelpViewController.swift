//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

class HelpViewController: CustomUIViewController {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  
  var menu: MenuList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let helpItemList = [MenuItem("Connecting bluetooth ClickRemote ", "pair"),
                            MenuItem("Using the ClickRemote", "remote"),
                            MenuItem("Using the app", "app"),
                            MenuItem("Voice navigation", "voice")]
    
    menu = MenuList(helpItemList)
    
    updateLabels()
    
    // Do any additional setup after loading the view.
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
    print("Left tap")
    goBack = true
    prevIdx = 4
    delegate?.transitionTo(viewId: "mainViewController", options: "")
  }
  override func handleTapRight(){
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "pair"{
      speak("Connect the clickmote by clicking into connect devices from main menu, and using the ‘Pair click remote’ menu item")
    }
    else if currentItemId == "remote" {
      speak("Swipe to scroll through menu items, click forward to interact with selected item, click back to move back to the previous menu layer")
    }
    else if currentItemId == "app" {
      speak("Navigate through the app using either a connected clickmote or performing swiping or clicking actions directly on the touchscreen. Setup bluetooth sensors to record sensor data during sessions")
    }
    else if currentItemId == "voice" {
      speak("Be sure to activate voice control in the app settings. To perform a voice command, say Hey Coacher. Upon detecting your voice, the app will make a noise to confirm it is listening, then proceed to say a command, such as ")
    }
    
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
