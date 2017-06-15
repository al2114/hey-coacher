//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

var analyzeSessionId: Int = 0

class SessionAnalysisViewController: CustomUIViewController {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  var sessionClass: String = ""
  var sessionTime: String = ""
  var sessionDistance: Double = 0
  var sessionAveragePace: Double = 0
  var quarterPace: [Double] = []
  var paceComparison: Double = 0
  var compareCount: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let sessionAnalysisItemList = [MenuItem("Overall performance","overall"),
                                   MenuItem("Split pace","split"),
                                   MenuItem("Compare to previous sessions","compare")]
    
    menu = MenuList(sessionAnalysisItemList)
    updateLabels()
    
    
    
    let jsonString = serviceAnalyzeSession(analyzeSessionId)
    do {
      let json = try JSON(data: jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
      sessionClass = json["class"].stringValue
      sessionTime = "\(json["minutes"].stringValue) minute and \(json["seconds"].stringValue) seconds"
      sessionDistance = json["distance"].double!
      sessionAveragePace = json["averagepace"].double!
      quarterPace = [json["q1"].double!, json["q2"].double!, json["q3"].double!, json["q4"].double!]
      paceComparison = json["comparison"].double!
      compareCount = json["count"].int!
    } catch {
      print("error")
    }
    
    
    // Do any additional setup after loading the view.
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
    delegate?.transitionTo(viewId: "analysisViewController", options: "")
  }
  override func handleTapRight(){
    
    let currentItemId: String = (menu?.currentId())!
    
    if currentItemId == "overall"{
      speak("Total time: \(sessionTime). Distance: \(sessionDistance) km. Average pace: \(sessionAveragePace) minutes per km. ")
    }
    else if currentItemId == "split"{
      
      var paceString = "Quarterly split pace."
      for i in 0...3 {
        paceString += " Quarter \(i+1): \(quarterPace[i]) minutes per km."
      }
      
      speak(paceString)
    }
    else {
//      Compared to last the average of last five sessions, your average pace has improved by 12 seconds per kilometer
      
      var comparisonText = "Compared to your last \(compareCount) sessions"
      if paceComparison >= 0 {
        comparisonText += " your average pace has improved by \(paceComparison) seconds per km."
      } else {
        comparisonText += " your average pace has decreased by \(-paceComparison) seconds per km."
      }
      speak(comparisonText)
    }
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
