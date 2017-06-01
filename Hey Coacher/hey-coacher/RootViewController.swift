//
//  ViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

enum ActionKey {
  case swipeLeft
  case swipeRight
  case tapLeft
  case tapRight
}


class RootViewController: UIViewController, rootDelegate {
  
  @IBOutlet weak var containerView: UIView!
  
  weak var currentViewController: CustomUIViewController?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let initialState = "mainViewController"
    containerViewIntialize(initialState)

    
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
    
    leftSwipe.direction = .left
    rightSwipe.direction = .right
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    
    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(rightSwipe)
    view.addGestureRecognizer(tap)
       
  }
}

