//
//  ViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit
import AVFoundation

enum ActionKey {
  case swipeLeft
  case swipeRight
  case tapLeft
  case tapRight
}


class RootViewController: UIViewController,
                          AVSpeechSynthesizerDelegate,
                          OEEventsObserverDelegate,
                          RootDelegate

{
  
  @IBOutlet weak var containerView: UIView!
  weak var currentViewController: CustomUIViewController?
  
  var openEarsEventsObserver = OEEventsObserver()

  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    
    //============================================//
    
    //    OPENEARS OFFLINE VOICE RECOGNITION      //
    
    //============================================//
    
    let lmGenerator = OELanguageModelGenerator()
    
    
    let name = "NameIWantForMyLanguageModelFiles"
    let err: Error! = lmGenerator.generateLanguageModel(from: words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
    
    if(err != nil) {
      print("Error while creating initial language model: \(err)")
    } else {
      let lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name) // Convenience method to reference the path of a language model known to have been created successfully.
      let dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name) // Convenience method to reference the path of a dictionary known to have been created successfully.
      
      self.openEarsEventsObserver.delegate = self
      
      // OELogging.startOpenEarsLogging() //Uncomment to receive full OpenEars logging in case of any unexpected results.
      do {
        try OEPocketsphinxController.sharedInstance().setActive(true) // Setting the shared OEPocketsphinxController active is necessary before any of its properties are accessed.
      } catch {
        print("Error: it wasn't possible to set the shared instance to active: \"\(error)\"")
      }
      
      OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    //====================================//
    
    //    INITIALIZING CONTAINER VIEW     //
    
    //====================================//
    
    let initialState = "mainViewController"
    containerViewIntialize(initialState)

    //====================================//
    
    //    SPEECH SYNTEHSIZER DELEGATION   //
    
    //====================================//
    
    synthesizer.delegate = self

    
    //====================================//
    
    //          GESTURE RECOGNIZER        //
    
    //====================================//
    
    
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
    
    leftSwipe.direction = .left
    rightSwipe.direction = .right
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    
    view.addGestureRecognizer(leftSwipe)
    view.addGestureRecognizer(rightSwipe)
    view.addGestureRecognizer(tap)
    
    
  }
  
}

