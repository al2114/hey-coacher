//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit


var exercises: CycleList = CycleList([
  "biking",
  "walking",
  "jogging"
  ])

var exercise: String = exercises.currentItem

class ExerciseViewController: CustomUIViewController {

  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  override func viewDidLoad() {
      super.viewDidLoad()

      let exerciseItemList = [MenuItem("Begin \(exercise) session", "startsession"),
                          MenuItem("Change exercise, \(exercise) is currently selected", "selectexercise"),
//                          MenuItem("Create new exercise profile", "createexercise"),
                          MenuItem("Analyze overall performance", "analyze")]
  
    if goBack {
      menu = MenuList(exerciseItemList, idx: prevIdx)
      goBack = false
    }
    else {
      menu = MenuList(exerciseItemList)
    }
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
          print("Start Session")
                  delegate?.transitionTo(viewId: "sessionViewController", options: "")

        
      }
      else if currentItemId == "selectexercise"{
          exercises.iterNext()
          exercise = exercises.currentItem
          speak(exercise)
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
          delegate?.transitionTo(viewId: "analysisViewController", options: "")
//          analyzePerformance()
          //delegate?.transitionTo(viewId: "dataAnalyzeViewController")
      }
      
  }

  func analyzePerformance() {
    speak("Analyzing previous session: Biking, June 12th, 2017, 13:08. Total time: 16 minutes and 35 seconds. Distance: 5.0 km. Average pace: 3.32 minutes per km. Quarterly split pace. First quarter: 3.39 minutes per km. second quarter: 3.10 minutes per km, third quarter: 3.29 minutes per km, fourth quarter: 3.50 minutes per km.")
    
    speakWait("Compared to last the average of last five sessions, your average pace has improved by 12 seconds per kilometer")
  }
  
  func updateLabels(){
      mainLabel.text = menu?.currentItem;
      prevLabel.text = menu?.previousItem
      nextLabel.text = menu?.nextItem;
  }
}
