//
//  ExerciseViewController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import CoreLocation
import HealthKit
var distanceUnit: HKUnit = HKUnit(from: "km")
var paceUnit: HKUnit = HKUnit.second().unitDivided(by: HKUnit.meter())

class SessionViewController: CustomUIViewController,
                             CLLocationManagerDelegate
{
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var prevLabel: UILabel!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var beginsessionLabel: UILabel!
  
  var menu: MenuList?
  
  var backConfirm: Bool = false
  
  var seconds = 0.0
  var distance = 0.0

  
  let locationManager = CLLocationManager()
  
  
  //
//  lazy var locationManager: CLLocationManager = {
//    var _locationManager = CLLocationManager()
//    _locationManager.delegate = self
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    _locationManager.activityType = .fitness
//    
//    // Movement threshold for new events
//    _locationManager.distanceFilter = 10.0
//    return _locationManager
//  }()
  
  lazy var locations = [CLLocation]()
  lazy var sessionTimer = Timer()
  
  let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
    let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
    let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
    
    
    if userID != 41 {
    
    let exerciseItemList = [MenuItem("Time: \(timeToString(seconds))", "reading-time"),
//                            MenuItem("Distance: \(Double(Int(distanceQuantity.doubleValue(for: distanceUnit)*10))/10) km", "reading-distance"),
                              MenuItem("Distance: \(Double(Int(distanceQuantity.doubleValue(for: distanceUnit)*10))/10) km", "reading-distance"),
//                            MenuItem("Heartrate: \(heartrate) BPM", "reading-heartrate"),
                            MenuItem("Heartrate: n/a", "reading-heartrate"),

//                            MenuItem("Cadence: \(cadence) rounds per minute", "reading-cadence"),
                            MenuItem("Cadence: n/a", "reading-cadence"),
                            MenuItem("Pace: \(paceToString(1000*paceQuantity.doubleValue(for: paceUnit)))", "reading-pace"),
                            MenuItem("Analyze current performance", "analyze")]
    
    menu = MenuList(exerciseItemList, message: "Session started")
    updateLabels()
  
    seconds = 0.0
    distance = 0.0
    locations.removeAll(keepingCapacity: false)
    sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      print("Starting location tracking")
      locationManager.startUpdatingLocation()
      locationManager.startMonitoringSignificantLocationChanges()
      locationManager.distanceFilter = 10
    } else {
      print("Location services not enabled")
    }
      
    }
    
    else {
      
      let exerciseItemList = [MenuItem("Time: \(timeToString(seconds))", "reading-time"),
                              //                            MenuItem("Distance: \(Double(Int(distanceQuantity.doubleValue(for: distanceUnit)*10))/10) km", "reading-distance"),
        MenuItem("Distance: 0.7 km", "reading-distance"),
        //                            MenuItem("Heartrate: \(heartrate) BPM", "reading-heartrate"),
        MenuItem("Heartrate: 93 bpm", "reading-heartrate"),
        
        //                            MenuItem("Cadence: \(cadence) rounds per minute", "reading-cadence"),
        MenuItem("Cadence: 23.4 revolutions per minute", "reading-cadence"),
        MenuItem("Pace: 4 minutes and 30 seconds per kilometer", "reading-pace"),
        MenuItem("Analyze current performance", "analyze")]
      
      menu = MenuList(exerciseItemList, message: "Session started")
      updateLabels()
      
      seconds = 0.0
      sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
      

    }
    serviceBeginSession(exercise)
    print("beginning session with uid: \(userID)")
    
  }
  
  override func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(false)
    locationManager.requestAlwaysAuthorization()

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(false)
    serviceEndSession()
    sessionTimer.invalidate()
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
      print("Data Analysis")
      analyzePerformance()
      //delegate?.transitionTo(viewId: "dataAnalyzeViewController")
    }
    else {
      speak((menu?.currentItem)!)
    }
  }
  func updateLabels(){
    mainLabel.text = menu?.currentItem;
    prevLabel.text = menu?.previousItem
    nextLabel.text = menu?.nextItem;
  }
  
  func eachSecond(timer: Timer) {
    seconds += 1
    interval = seconds
    let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
    menu?.updateItemDesc(itemId: "reading-time", newDesc: "Time: \(timeToString(seconds))")
    
    let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
//    menu?.updateItemDesc(itemId: "reading-distance", newDesc: "Distance: \(Double(Int(distanceQuantity.doubleValue(for: distanceUnit)*10))/10) km")
    if userID != 41 {
        menu?.updateItemDesc(itemId: "reading-distance", newDesc: "Distance: \(Double(Int(distanceQuantity.doubleValue(for: distanceUnit)*10))/10) km")
    
    }
    
    updateLabels()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for location in locations {
      if location.horizontalAccuracy < 20 {
        //update distance
        if self.locations.count > 2 {
          print("Distance from last: \(location.distance(from: self.locations.last!))")
          distance += location.distance(from: self.locations.last!)
          
          let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
          menu?.updateItemDesc(itemId: "reading-pace", newDesc: "Pace: \(paceToString(1000*paceQuantity.doubleValue(for: paceUnit)))")
        }
        
        //save location
        self.locations.append(location)
      }
    }
  }
  
}

func analyzePerformance() {
  
  if userID != 41 {
    speak("You're going slower than your average pace. Keep pushing! You can do better!")
    
  }
  else {
    let jsonText = serviceAnlyzeCurrentSession()
    
    print(jsonText)
    
    if let result = jsonToDictionary(text: jsonText) {
      print("Speaking: \(String(describing: result["analysis"]))")
      speak(result["analysis"] as! String)
      print("Speaking: \(String(describing: result["motivation"]))")
      speakWait(result["motivation"] as! String)
    }
    else {
      print("error")
    }
  }
}

