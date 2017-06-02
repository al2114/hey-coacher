//  sessionViewController.swift
//  Hey Coacher
//
//  Created by Prakhar Lunia on 6/1/17.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation

class OldSessionViewController: CustomUIViewController {
    @IBOutlet weak var displayTextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func handleSwipeLeft(){
        if let url = URL(string: "http://databasequerypage.azurewebsites.net/query.aspx?request=value&reading=Pace&sid=\(sessionID)") {
            do {
                var contents = try String(contentsOf: url, encoding: .utf8)
                let summarydata = contents.format()
                let summarydataArr = summarydata.components(separatedBy: " ")
                
                let pacevalue = summarydataArr[5]
                
                let utterace = AVSpeechUtterance(string: "Your pace is " + pacevalue + " minutes per km")
                utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterace.rate = 0.45
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterace)
                displayTextLabel.text = "Your pace is " + pacevalue + " min/km"
            }
            catch {
                print("Contents could not be loaded")
            }
        }
        else {
            print("The URL was bad")
        }
    }
    
    override func handleSwipeRight(){
        let utterace = AVSpeechUtterance(string: "Your cadence is  rpm")
        utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterace.rate = 0.45
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterace)
        displayTextLabel.text = "Your cadence is  rpm"
    }
    
    override func handleTapLeft(){
        let utterace = AVSpeechUtterance(string: "Your heart rate is  bpm")
        utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterace.rate = 0.45
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterace)
        displayTextLabel.text = "Your heart rate is  bpm"
    }
    
    override func handleTapRight(){
        let utterace = AVSpeechUtterance(string: "Your distance travelled is  m")
        utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterace.rate = 0.45
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterace)
        displayTextLabel.text = "Your distance travelled is  m"
    }
    
    @IBAction func endSessionButton(_ sender: Any) {
        if let url = URL(string: "http://databasequerypage.azurewebsites.net/query.aspx?request=endsession&sid=\(sessionID)") {
            do {
                var contents = try String(contentsOf: url, encoding: .utf8)
                let summarydata = contents.format()
                let summarydataArr = summarydata.components(separatedBy: " ")
                if(summarydataArr[4] == "Session" && summarydataArr[5] == "Ended"){
                    print ("Session Ended")
                    delegate?.transitionTo(viewId: "mainViewController", options: "")
                }
            }
            catch {
                print("Contents could not be loaded")
            }
        }
        else {
            print("The URL was bad")
        }
    }
}
