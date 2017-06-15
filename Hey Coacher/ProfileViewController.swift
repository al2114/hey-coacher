//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

struct User{
  init(name: String, id: String) {
    self.name = name
    self.id = id
  }
  var name: String
  var id: String
}

var userList: [User] = [
  User(name: "Mark", id: "41"),
  User(name: "Michael", id: "3"),
  User(name: "Andy", id: "7"),
  User(name: "Prakhar", id: "29")
]

class ProfileViewController: CustomUIViewController {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var profileList: [MenuItem] = []
    
    for user in userList {
      profileList += [MenuItem(user.name, user.id)]
    }

//    profileList += [MenuItem("Create new profile", "newprofile")]
    
    menu = MenuList(profileList, message: "Select a profile")
    updateLabels()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    if entrySpeech {
      entrySpeech = false
    }
    
    print("Left tap")
    goBack = true
    prevIdx = 0
    delegate?.transitionTo(viewId: "mainViewController", options: "")
  }
  override func handleTapRight(){
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "newprofile" {
      print("new profile")
    }
    else {
      for user in userList {
        if user.id == currentItemId{
          name = user.name
          speak("Selected \(user.name)")
          userID = Int(user.id)!
          welcome = true
        }
      }
    }
    
    
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
