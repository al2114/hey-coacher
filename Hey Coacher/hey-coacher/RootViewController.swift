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
                          RootDelegate  {
  
  @IBOutlet weak var containerView: UIView!
  weak var currentViewController: CustomUIViewController?
  
  var openEarsEventsObserver = OEEventsObserver()
  
  let lmGenerator = OELanguageModelGenerator()

  let OEname = "HeyCoacherLanguageModel"

  var lmPath: String = ""
  var dicPath: String = ""
  

  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    
    self.accessibilityElementsHidden = true
    self.containerView.accessibilityElementsHidden = true
    
    //============================================//
    
    //    OPENEARS OFFLINE VOICE RECOGNITION      //
    
    //============================================//
    
    
    
    let err: Error! = lmGenerator.generateLanguageModel(from: words, withFilesNamed: OEname, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
    
    if(err != nil) {
      print("Error while creating initial language model: \(err)")
    } else {

      let lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: OEname) // Convenience method to reference the path of a language model known to have been created successfully.
      let dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: OEname) // Convenience method to reference the path of a dictionary known to have been created successfully.
      
      self.openEarsEventsObserver.delegate = self
      
      // OELogging.startOpenEarsLogging() //Uncomment to receive full OpenEars logging in case of any unexpected results.
      
      do {
        try OEPocketsphinxController.sharedInstance().setActive(true) // Setting the shared OEPocketsphinxController active is necessary before any of its properties are accessed.
      } catch {
        print("Error: it wasn't possible to set the shared instance to active: \"\(error)\"")
      }
      
      if !OEPocketsphinxController.sharedInstance().micPermissionIsGranted {
        OEPocketsphinxController.sharedInstance().requestMicPermission()
      } else {
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
      }
      
    }
    
    //====================================//
    
    //    INITIALIZING CONTAINER VIEW     //
    
    //====================================//
    
    let initialState = "mainViewController"
    currentViewControllerIdentifier = initialState
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

