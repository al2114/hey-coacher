//
//  SpeechEngine.swift
//  Hey Coacher
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import AVFoundation

var entrySpeech: Bool = false
let UTTERANCE_RATE = AVSpeechUtteranceDefaultSpeechRate
var UTTERANCE_VOICE: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: "en-us")!

func speak(_ message: String){
  if !speechEnabled{
    return
  }
  
  if synthesizer.isSpeaking{
    synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
  }
  let speechText: String = message
  let speechUtterance = AVSpeechUtterance(string: speechText)
  speechUtterance.rate = UTTERANCE_RATE
  speechUtterance.voice = UTTERANCE_VOICE
  synthesizer.speak(speechUtterance)
}

func speakWait(_ message: String){
  if !speechEnabled{
    return
  }
  
  let speechText: String = message
  let speechUtterance = AVSpeechUtterance(string: speechText)
  speechUtterance.rate = UTTERANCE_RATE
  speechUtterance.voice = UTTERANCE_VOICE
  synthesizer.speak(speechUtterance)
}

var synthesizer = AVSpeechSynthesizer()
var totalUtterance: Int = 0

extension RootViewController{
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                         didFinish utterance: AVSpeechUtterance)
  {

  }
}


