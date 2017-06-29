//
//  GestureHandler.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation


extension RootViewController{
  func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    if (sender.direction == .left){
      //      self.currentViewController?.actionHandler(action: .SwipeLeft)
      currentViewController?.handleAction(action: .swipeLeft)
    }
    else if (sender.direction == .right){
      //      self.currentViewController?.actionHandler(action: .SwipeRight)
      currentViewController?.handleAction(action: .swipeRight)
    }
  }

  func tapHandler(_ sender: UITapGestureRecognizer) {
    
    let p = sender.location(in: view)
    
    if p.x < (UIScreen.main.bounds.size.width/2) {
      //      self.currentViewController?.actionHandler(action: .TapLeft)
      currentViewController?.handleAction(action: .tapLeft)
      
    }
    else {
      //      self.currentViewController?.actionHandler(action: .TapRight)
      currentViewController?.handleAction(action: .tapRight)
    }
  }
}
