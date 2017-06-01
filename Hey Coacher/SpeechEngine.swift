//
//  SpeechEngine.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import AVFoundation

var entrySpeech: Bool = false


func speak(_ message: String){
  if synthesizer.isSpeaking{
    synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
  }
  let speechText: String = message
  let speechUtterance = AVSpeechUtterance(string: speechText)
  speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
  speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
  synthesizer.speak(speechUtterance)
}

func speakWait(_ message: String){
  let speechText: String = message
  let speechUtterance = AVSpeechUtterance(string: speechText)
  speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
  speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
  synthesizer.speak(speechUtterance)
}

var synthesizer = AVSpeechSynthesizer()
var totalUtterance: Int = 0

extension RootViewController{
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                         didFinish utterance: AVSpeechUtterance)
  {
    if entrySpeech {
      entrySpeech = false
    }
  }
}


