//
//  BluetoothViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 12/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

class BluetoothViewController: CustomUIViewController {

  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  
  var menu: MenuList?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let mainItemList = [MenuItem("Pair your Clickmote device", "remote"),
                        MenuItem("Connect bluetooth sensors", "bt-sensors")]
  
    menu = MenuList(mainItemList)
    updateLabels()
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }

  
  
  override func handleSwipeLeft(){
    delegate?.stopScan()
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    
    menu?.iterNext()
    self.updateLabels()
  }
  override func handleSwipeRight(){
    delegate?.stopScan()
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    menu?.iterPrevious()
    self.updateLabels()
  }
  override func handleTapLeft(){
    delegate?.stopScan()
    goBack = true
    prevIdx = 2
    delegate?.transitionTo(viewId: "mainViewController", options: "")
    
  }
  override func handleTapRight(){
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "remote" {
      delegate?.connectRemote()
    }
    else if currentItemId == "bt-sensors" {
      delegate?.scanSensors()
      print("Bluetooth sensors")
    }
    
  }
  
  
  
}
