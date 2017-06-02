//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//


var heartrate: Int = 93
var cadence: Float = 23.4
var pace: TimeInterval = TimeInterval(438)
var distance: Float = 1.4
var interval: TimeInterval = TimeInterval(140)

func timeToString(_ time:TimeInterval) -> String {
  let minutes = Int(time) / 60
  let seconds = Int(time) % 60
  return "\(String(minutes)) minutes and \(String(seconds)) seconds"
}

class SessionViewController: CustomUIViewController {
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  var backConfirm: Bool = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let exerciseItemList = [MenuItem("Heartrate: \(heartrate) BPM", "reading-heartrate"),
                            MenuItem("Cadence: \(cadence) rounds per minute", "reading-cadence"),
                            MenuItem("Split pace: \(timeToString(pace))", "reading-pace"),
                            MenuItem("Distance: \(distance) kilometers", "reading-distance"),
                            MenuItem("Time: \(timeToString(interval))", "reading-time"),
                            MenuItem("Analyze current performance", "analyze")]
    
    
    menu = MenuList(exerciseItemList, message: "Session started")
    updateLabels()
    
    // Do any additional setup after loading the view.
  }
  
  override func handleSwipeLeft(){
    backConfirm = false
    menu?.iterNext()
    self.updateLabels()
  }
  override func handleSwipeRight(){
    backConfirm = false
    menu?.iterPrevious()
    self.updateLabels()
  }
  override func handleTapLeft(){
    print("Left tap")
    if backConfirm {
      delegate?.transitionTo(viewId: "mainViewController", options: "")
    }
    else {
      speak("Press back again to end session")
      backConfirm = true
    }
  }
  override func handleTapRight(){
    backConfirm = false
    print("Right tap")
    let currentItemId: String = (menu?.currentId())!
    if currentItemId == "analyze"{
      speak("This is the backend currently analyzing your performance. Keep it going!")
    } else {
      speak((menu?.currentItem)!)
    }
  }

  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
}
