//
//  RootContainerViewController.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

extension RootViewController {

  func containerViewIntialize(_ viewIdentifier: String){
    self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: viewIdentifier)  as? CustomUIViewController
    self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
    self.addChildViewController(self.currentViewController!)
    self.containerAddSubview(self.currentViewController!.view, toView: self.containerView)
    self.currentViewController?.delegate = self
  }
  
  func containerSwitchToViewController(_ viewIdentifier: String){
    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: viewIdentifier)
    newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
    cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
    self.currentViewController = newViewController as? CustomUIViewController
    self.currentViewController?.delegate = self
  }
  
  func containerAddSubview(_ subView:UIView, toView parentView:UIView) {
    parentView.addSubview(subView)
    
    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["subView"] = subView
    parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                             options: [], metrics: nil, views: viewBindingsDict))
    parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                             options: [], metrics: nil, views: viewBindingsDict))
  }
  
  func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
    oldViewController.willMove(toParentViewController: nil)
    self.addChildViewController(newViewController)
    self.containerAddSubview(newViewController.view, toView:self.containerView!)
    newViewController.view.alpha = 0
    newViewController.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.1, animations: {
      newViewController.view.alpha = 1
      oldViewController.view.alpha = 0
    },
                   completion: { finished in
                    oldViewController.view.removeFromSuperview()
                    oldViewController.removeFromParentViewController()
                    newViewController.didMove(toParentViewController: self)
    })
  }
  
}
