//
//  RootDelegateFunctions.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights 


var currentViewControllerIdentifier: String?

extension RootViewController {
  
  func transitionTo(viewId: String, options: String ){
    print("Root delegated, switching container view")
    currentViewControllerIdentifier = viewId
    containerSwitchToViewController(viewId)
  }
}
