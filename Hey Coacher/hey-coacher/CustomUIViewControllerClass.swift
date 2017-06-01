//
//  CustomUIViewControllerClass.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation

class CustomUIViewController: UIViewController, AVSpeechSynthesizerDelegate {
  
  var delegate: RootDelegate?
  
  func handleAction(action: ActionKey){
    switch action{
    case .swipeLeft:
      self.handleSwipeLeft()
    case .swipeRight:
      self.handleSwipeRight()
    case .tapLeft:
      self.handleTapLeft()
    case .tapRight:
      self.handleTapRight()
    }
  }
  
  func handleSwipeLeft(){
    print("Left swipe")
  }
  func handleSwipeRight(){
    print("Right swipe")
  }
  func handleTapLeft(){
    print("Left tap")
  }
  func handleTapRight(){
    print("Right tap")
  }
  
  
}


protocol RootDelegate {
  func transitionTo(viewId: String)
}
