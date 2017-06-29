//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

class AnalysisViewController: CustomUIViewController {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: SessionList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var analyzeItemList: [SessionItem] = []
    
    
    let jsonString = serviceGetSessions()
    do {
      let json = try JSON(data: jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
      for idx in 0...(json.count-1) {
        let sessionClass = json[idx]["class"].stringValue
        let sessionDate = json[idx]["date"].stringValue
        let sessionTime = json[idx]["time"].stringValue
        let sid = json[idx]["sid"].int
        
        analyzeItemList += [SessionItem("\(sessionClass) session on \(sessionDate) at \(sessionTime)", sid!)]
      }
    } catch {
      print("error")
    }
    
    if goBack {
      menu = SessionList(analyzeItemList, idx: prevIdx)
    }
    else {
      menu = SessionList(analyzeItemList, message:("Select a session to analyze"))
    }
    updateLabels()
    
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
    prevIdx = 3
    delegate?.transitionTo(viewId: "exerciseViewController", options: "")
  }
  override func handleTapRight(){
    
    if entrySpeech {
      entrySpeech = false
      speak((menu?.currentItem)!)
      return
    }
    
    let currentItemId: Int! = (menu?.currentId())!
    
    analyzeSessionId = currentItemId
    prevIdx = (menu?.idx)!
    
//    print(currentItemId)
//    print(Int(currentItemId)!)
//    if let s = currentItemId, let sid = Int(s) {
//      print("\(sid)")
//    }
//    print(currentItemId == "38")
//    if let sidString = currentItemId, let sid = Int(sidString) {
//      analyzeSessionId = sid
//      delegate?.transitionTo(viewId: "sessionAnalysisViewController", options: "")
//    } else {
//      print("error")
//    }
    
    
//    analyzeSessionId = Int(currentItemId)
    delegate?.transitionTo(viewId: "sessionAnalysisViewController", options: "")
    
  }
  
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
