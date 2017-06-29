//
//  VoiceControl.swift
//  Hey Coacher
//
//  Created by Andrew Li on 02/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

let words = [ "haycoacher",
              "begin session",
              "start session",
              "main menu",
              "end session",
              "check readings",
              "to mark",
              "switch profile",
              "settings",
              "irish accent",
              "current performance",
              "british accent",
              "anlysis",
]

//var inSession: Bool = false

extension RootViewController {
  func voiceCommand(_ cmd: String){
    
    if cmd == "begin session" ||
      cmd == "start session"
    {
      if currentViewControllerIdentifier != "sessionViewController" {
        transitionTo(viewId: "sessionViewController", options: "")
      }
      else {
        speak("You are currently already in a session")
      }
    }
    else if cmd == "main menu" {
      transitionTo(viewId: "mainViewController", options: "")
    }
    else if cmd == "to mark" {
      speak("Switching profile to Mark")
      name = "Mark"
      userID = 41
      welcome = true
    }
    else if cmd == "anlysis" || cmd == "performance" {
      if currentViewControllerIdentifier == "sessionViewController" {
        analyzePerformance()
      }
    }
    else if cmd == "end session"{
      if currentViewControllerIdentifier == "sessionViewController" {
        speak("Ending session")
        serviceEndSession()
        transitionTo(viewId: "mainViewController", options: "")
      }
      else {
        speak("You are not currently in a session")
      }
    }
    else if cmd == "check readings"{
      
      if currentViewControllerIdentifier == "sessionViewController" {
          var readings: String = ""
          readings =  "Time: \(timeToString(interval)), " +
            "Distance: \(distance) kilometers, " +
            "Heartrate: \(heartrate) BPM, " +
          "Cadence: \(cadence) revolutions per minute "
          
          speak(readings)
      }
      else {
        speak("You are not currently in a session")
      }

    }
    else if cmd == "switch profile"{
      transitionTo(viewId: "profileViewController", options: "")
    }
    else if cmd == "settings"{
      transitionTo(viewId: "settingsViewController", options: "")
    }
    else if cmd == "british accent"{
      utteranceVoice = AVSpeechSynthesisVoice(language: "en-GB")!
      speak("Ok, done")
    }
    else if cmd == "irish accent"{
      utteranceVoice = AVSpeechSynthesisVoice(language: "en-IE")!
      speak("Ok, done")
    }
  }
}
