//
//  AudioEffects.swift
//  Hey Coacher
//
//  Created by Andrew Li on 10/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import AVFoundation

var player: AVAudioPlayer?

func playSound(_ soundfile: String) {
  guard let url = Bundle.main.url(forResource: soundfile, withExtension: "mp3") else {
    print("error")
    return
  }
  
  do {
//    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//    try AVAudioSession.sharedInstance().setActive(true)
    
    player = try AVAudioPlayer(contentsOf: url)
    guard let player = player else { return }
    
    player.play()
//    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
//    try AVAudioSession.sharedInstance().setActive(true)
  } catch let error {
    print(error.localizedDescription)
  }
  
}
