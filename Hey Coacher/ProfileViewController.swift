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
  User(name: "John", id: "1239"),
  User(name: "Mark", id: "1245")
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
      profileList += [MenuItem(user.name, "uid-"+user.id)]
    }

    profileList += [MenuItem("Create new profile", "newProfile")]
    
    
    menu = MenuList(profileList)
    updateLabels()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    delegate?.transitionTo(viewId: "mainViewController")
  }
  override func handleTapRight(){
    let currentItemId: String = (menu?.currentId())!
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
