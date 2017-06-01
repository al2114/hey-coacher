//  sessionViewController.swift
//  Hey Coacher
//
//  Created by Prakhar Lunia on 6/1/17.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation

class SessionViewController: CustomUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func handleSwipeLeft(){
        if let url = URL(string: "http://databasequerypage.azurewebsites.net/query.aspx?request=value&reading=HRate&sid=\(sessionID)") {
            do {
                var contents = try String(contentsOf: url, encoding: .utf8)
                let summarydata = contents.format()
                let summarydataArr = summarydata.components(separatedBy: " ")
                
                let hrate = summarydataArr[5]
                
                let utterace = AVSpeechUtterance(string: "Your heart rate is " + hrate + " bpm")
                utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterace.rate = 0.45
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterace);
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
        print("Cadence")
    }
    override func handleTapLeft(){
        print("Distance")
    }
    override func handleTapRight(){
        print("Pace")
    }
    
    @IBAction func endSessionButton(_ sender: Any) {
        if let url = URL(string: "http://databasequerypage.azurewebsites.net/query.aspx?request=endsession&sid=\(sessionID)") {
            do {
                var contents = try String(contentsOf: url, encoding: .utf8)
                let summarydata = contents.format()
                let summarydataArr = summarydata.components(separatedBy: " ")
                if(summarydataArr[4] == "Session" && summarydataArr[5] == "Ended"){
                    print ("Session Ended")
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
