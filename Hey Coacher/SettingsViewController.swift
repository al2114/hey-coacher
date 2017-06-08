//
//  SettingsViewController.swift
//  Hey Coacher
//
//  Created by Prakhar Lunia on 6/1/17.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

var utteranceRates: CycleList = CycleList([
  "Normal",
  "Fast",
  "Very fast",
  "Maximum"
  ])

var voices: CycleList = CycleList ([
  "en-US",
  "en-GB",
  "en-AU",
  "en-IE"
  ])
var utteranceRateId: String = "Normal"

func languageFromCode(_ lang: String) -> String {
  if lang == "en-US" {
    return "English (American)"
  }
  else if lang == "en-GB" {
    return "English (British)"
  }
  else if lang == "en-AU" {
    return "English (Australian)"
  }
  else if lang == "en-IE"{
    return "English (Irish)"
  }
  return ""
}

class SettingsViewController: CustomUIViewController {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var prevLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
 
    var menu: MenuList?

    override func viewDidLoad() {
        super.viewDidLoad()
      
      let settingsItemList = [MenuItem("Voice: \(languageFromCode(utteranceVoice.language))", "voice"),
                            MenuItem("Utterance rate: \(utteranceRateId)", "utterancerate")]
        
        menu = MenuList(settingsItemList)
        updateLabels()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleSwipeLeft(){
        menu?.iterNext()
        self.updateLabels()
    }
    override func handleSwipeRight(){
        menu?.iterPrevious()
        self.updateLabels()
    }
    override func handleTapLeft(){
      goBack = true
      prevIdx = 3
      delegate?.transitionTo(viewId: "mainViewController", options: "")
    }
    override func handleTapRight(){
      let currentItemId: String = (menu?.currentId())!
      
      if currentItemId == "utterancerate" {
        utteranceRates.iterNext()
        utteranceRateId = utteranceRates.currentItem
        updateUtteranceRate(utteranceRateId)
        menu?.updateItemDesc(itemId: "utterancerate", newDesc: "Utterance rate: \(utteranceRateId)")
        updateLabels()
        speak(utteranceRateId)
      }
      else if currentItemId == "voice"{
        voices.iterNext()
        utteranceVoice = AVSpeechSynthesisVoice(language: voices.currentItem)!
        menu?.updateItemDesc(itemId: "voice", newDesc: "Voice: \(languageFromCode(voices.currentItem))")
        updateLabels()
        speak((languageFromCode(voices.currentItem)))
      }
    
    }
  
  func updateUtteranceRate(_ id: String ){
    if id == "Normal"{
      utteranceRate = AVSpeechUtteranceDefaultSpeechRate
    }
    else if id == "Fast" {
      utteranceRate = AVSpeechUtteranceDefaultSpeechRate*1.3
    }
    else if id == "Very fast" {
      utteranceRate = AVSpeechUtteranceDefaultSpeechRate*1.7
    }
    else if id == "Maximum" {
      utteranceRate = AVSpeechUtteranceMaximumSpeechRate
    }
  }
  
  func updateLabels(){
      mainLabel.text = menu?.currentItem;
      prevLabel.text = menu?.previousItem
      nextLabel.text = menu?.nextItem;
  }

}
