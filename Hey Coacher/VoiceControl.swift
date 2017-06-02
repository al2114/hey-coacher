//
//  VoiceControl.swift
//  Hey Coacher
//
//  Created by Andrew Li on 02/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

let words = [ "hey coacher",
              "begin session",
              "check readings",
              "irish accent",
              "british accent",
              "switch to",
              "change to"
]

extension RootViewController {
  func voiceCommand(_ cmd: String){
    
    if cmd == "begin session"{
      transitionTo(viewId: "sessionViewController", options: "")
    }
    else if cmd == "check readings"{
      var readings: String = ""
      
      readings =  "Time: \(timeToString(interval)), " +
                  "Distance: \(distance) kilometers, " +
                  "Heartrate: \(heartrate) BPM, " +
                  "Cadence: \(cadence) rounds per minute "
      
      speak(readings)
    }
    else if cmd == "british accent"{
      UTTERANCE_VOICE = AVSpeechSynthesisVoice(language: "en-GB")!
      speak("Ok, done")
    }
    else if cmd == "irish accent"{
      UTTERANCE_VOICE = AVSpeechSynthesisVoice(language: "en-IE")!
      speak("Ok, done")
    }
  }
}
