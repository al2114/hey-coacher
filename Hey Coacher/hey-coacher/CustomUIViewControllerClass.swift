//
//  CustomUIViewControllerClass.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit


class CustomUIViewController: UIViewController {
  
  var delegate: rootDelegate?
  
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


protocol rootDelegate {
  func transitionTo(viewId: String)
}
