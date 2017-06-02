//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
var userID: Int = 1
var sessionID: Int = 0

class ExerciseList {
    var idx: Int = 0
    var count: Int = 0
    var exercises = [String]()
    
    
    init(_ exercises: [String]){
        self.exercises = exercises
        self.count = exercises.count
    }
    
    
    func iterNext() {
        idx = mod(idx+1,count)
        speak(currentExercise)
    }
    
    var currentExercise: String {
        return exercises[idx]
    }
    
    
}

var exercises: ExerciseList = ExerciseList([
  "cycling",
  "walking",
  "jogging"
  ])

class ExerciseViewController: CustomUIViewController {

  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  var exercise: String = exercises.currentExercise
    
  
  override func viewDidLoad() {
      super.viewDidLoad()

      let exerciseItemList = [MenuItem("Start \(exercise) session", "startsession"),
                          MenuItem("Change exercise, \(exercise) is currently selected", "selectexercise"),
                          MenuItem("Create new exercise profile", "createexercise"),
                          MenuItem("Analyze overall performance", "analyze")]
  
      
      menu = MenuList(exerciseItemList)
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
      prevIdx = 1
      delegate?.transitionTo(viewId: "mainViewController", options: "")
  }
  override func handleTapRight(){
      let currentItemId: String = (menu?.currentId())!
      
      if currentItemId == "startsession"{
//          print("Start Session")
//          if let url = URL(string: "http://databasequerypage.azurewebsites.net/query.aspx?request=startsession&id=\(userID)&class=\(exercise)") {
//              do {
//                  var contents = try String(contentsOf: url, encoding: .utf8)
//                  let summarydata = contents.format()
//                  let summarydataArr = summarydata.components(separatedBy: " ")
//                  
//                  sessionID = Int(summarydataArr[4])!
                  delegate?.transitionTo(viewId: "sessionViewController", options: "")
//              }
//              catch {
//                  print("Contents could not be loaded")
//              }
//          }
//          else {
//              print("The URL was bad")
//          }
        
      }
      else if currentItemId == "selectexercise"{
          exercises.iterNext()
          exercise = exercises.currentExercise
          print(exercise)
          menu?.updateItemDesc(itemId: "startsession", newDesc: "Start \(exercise) session")
          menu?.updateItemDesc(itemId: "selectexercise", newDesc: "Change exercise, \(exercise) is currently selected")
          updateLabels()
        
        
          //print("Select Session")
          //delegate?.transitionTo(viewId: "selectExerciseViewController")
      }
      else if currentItemId == "createexercise"{
          print("Create Exercise")
          //delegate?.transitionTo(viewId: "createExerciseViewController")
      }
      else if currentItemId == "analyze"{
          print("Data Analysis")
          //delegate?.transitionTo(viewId: "dataAnalyzeViewController")
      }
      
  }

  func updateLabels(){
      mainLabel.text = menu?.currentItem;
      prevLabel.text = menu?.previousItem
      nextLabel.text = menu?.nextItem;
  }
}
