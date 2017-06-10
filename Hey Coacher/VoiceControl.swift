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
              "switch profile",
              "settings",
              "irish accent",
              "british accent",
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
    else if cmd == "end session"{
      if currentViewControllerIdentifier == "sessionViewController" {
        speak("Ending session")
        transitionTo(viewId: "mainViewController", options: "")
      }
      else {
        speak("You are not currently in a session")
      }
    }
    else if cmd == "check readings"{
      var readings: String = ""
      
      readings =  "Time: \(timeToString(interval)), " +
                  "Distance: \(distance) kilometers, " +
                  "Heartrate: \(heartrate) BPM, " +
                  "Cadence: \(cadence) rounds per minute "
      
      speak(readings)
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
