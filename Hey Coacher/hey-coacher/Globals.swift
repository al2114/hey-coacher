//
//  RemoteEngine.swift
//  hey-coacher
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import Foundation


var heartrate: Int = 93
var cadence: Float = 23.4
var pace: TimeInterval = TimeInterval(438)
var distance: Float = 0.7
var interval: TimeInterval = TimeInterval(140)

var userID: Int = 34
var sessionID: Int = 70


var speechEnabled: Bool = true

import UIKit

// Parity based on operand mod
func mod(_ a: Int, _ n: Int) -> Int {
  precondition(n > 0, "modulus must be positive")
  let r = a % n
  return r >= 0 ? r : r + n
}


func timeToString(_ time:TimeInterval) -> String {
  var timeString = ""
  
  let minutes = Int(time) / 60
  let seconds = Int(time) % 60
  
  if minutes != 0 {
    timeString += "\(String(minutes)) minutes"
    if seconds != 0 {
      timeString += " and \(String(seconds)) seconds"
    }
  }
  else {
    timeString += "\(String(seconds)) seconds"
  }
  
  return timeString
}

func paceToString(_ pace:Double) -> String {
  
  if !pace.isFinite{
    return "n/a"
  }
  else {
    var paceString = ""
    let minutes = Int(pace) / 60
    let seconds = Int(pace) % 60
    
    paceString += "\(minutes) minutes"
    if seconds != 0 {
      paceString += " and \(seconds) seconds"
    }
    return "\(paceString) per kilometer"
  }
}

func distanceToString(_ distance:Double) -> String {
  
  
  let hundreds = Int(distance/100)%10
  let km = Int(distance/100)/10

  var distanceString = "\(km)"

  if hundreds != 0 {
    distanceString += ".\(hundreds)"
  }
  
  return "\(distanceString) km"

}

extension String {
    func deleteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func deleteHTMLTag() -> String {
        return self.replacingOccurrences(of:"<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    func deleteLines() -> String {
        return components(separatedBy: CharacterSet.newlines).joined()
    }
    mutating func formatting() -> String{
        self = self.deleteLines()
        self = self.deleteSpaces()
        self = self.deleteHTMLTag()
        return self
    }
    mutating func format() -> String{
      self = self.deleteLines()
      self = self.deleteHTMLTag()
      let idx = self.index(self.startIndex, offsetBy: 4)
      self = self.substring(from: idx)
      return self
    }
}


func jsonToDictionary(text: String) -> [String: Any]? {
  if let data = text.data(using: .utf8) {
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      print(error.localizedDescription)
    }
  }
  return nil
}
