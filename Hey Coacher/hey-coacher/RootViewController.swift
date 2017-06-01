//
//  ViewController.swift
//  test-structure
//
//  Created by Andrew Li on 30/05/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import UIKit

enum ActionKey {
  case swipeLeft
  case swipeRight
  case tapLeft
  case tapRight
}


class RootViewController: UIViewController, OEEventsObserverDelegate, rootDelegate {
  
  @IBOutlet weak var containerView: UIView!
  weak var currentViewController: CustomUIViewController?
  
  var openEarsEventsObserver = OEEventsObserver()
  
  let words = [ "hey coacher",
                "begin session",
                "enable",
                "disable",
                "check readings"]
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    
    
    //============================================//
    
    //    OPENEARS OFFLINE VOICE RECOGNITION      //
    
    //============================================//
    
    print("Sup")
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
  
  
  // Methods for Openears
  
  func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) { // Something was heard
    //    print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)")
    print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)")
    if words.contains(hypothesis) {
      print("Detected word: \"\(hypothesis!)\"")
    }
    
  }
  
  // An optional delegate method of OEEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
  // This might be useful in debugging a conflict between another sound class and Pocketsphinx.
  func pocketsphinxRecognitionLoopDidStart() {
    print("Local callback: Pocketsphinx started.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is now listening for speech.
  func pocketsphinxDidStartListening() {
    print("Local callback: Pocketsphinx is now listening.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
  func pocketsphinxDidDetectSpeech() {
    //    print("Local callback: Pocketsphinx has detected speech.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance.
  func pocketsphinxDidDetectFinishedSpeech() {
    //    print("Local callback: Pocketsphinx has detected a second of silence, concluding an utterance.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx has exited its recognition loop, most
  // likely in response to the OEPocketsphinxController being told to stop listening via the stopListening method.
  func pocketsphinxDidStopListening() {
    print("Local callback: Pocketsphinx has stopped listening.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
  // Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
  // in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
  // or as a result of the OEPocketsphinxController being told to suspend recognition via the suspendRecognition method.
  func pocketsphinxDidSuspendRecognition() {
    print("Local callback: Pocketsphinx has suspended recognition.") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
  // having been suspended it is now resuming.  This can happen as a result of Flite speech completing
  // on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
  // or as a result of the OEPocketsphinxController being told to resume recognition via the resumeRecognition method.
  func pocketsphinxDidResumeRecognition() {
    print("Local callback: Pocketsphinx has resumed recognition.") // Log it.
  }
  
  // An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
  // recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
  func pocketsphinxDidChangeLanguageModel(toFile newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
    
    print("Local callback: Pocketsphinx is now using the following language model: \n\(newLanguageModelPathAsString!) and the following dictionary: \(newDictionaryPathAsString!)")
  }
  
  // An optional delegate method of OEEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
  // complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
  func fliteDidStartSpeaking() {
    print("Local callback: Flite has started speaking") // Log it.
  }
  
  // An optional delegate method of OEEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
  // complex interaction between sound classes.
  func fliteDidFinishSpeaking() {
    print("Local callback: Flite has finished speaking") // Log it.
  }
  
  func pocketSphinxContinuousSetupDidFail(withReason reasonForFailure: String!) { // This can let you know that something went wrong with the recognition loop startup. Turn on [OELogging startOpenEarsLogging] to learn why.
    print("Local callback: Setting up the continuous recognition loop has failed for the reason \(reasonForFailure), please turn on OELogging.startOpenEarsLogging() to learn more.") // Log it.
  }
  
  func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String!) { // This can let you know that something went wrong with the recognition loop startup. Turn on OELogging.startOpenEarsLogging() to learn why.
    print("Local callback: Tearing down the continuous recognition loop has failed for the reason \(reasonForFailure)") // Log it.
  }
  
  /** Pocketsphinx couldn't start because it has no mic permissions (will only be returned on iOS7 or later).*/
  func pocketsphinxFailedNoMicPermissions() {
    print("Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.")
  }
  
  /** The user prompt to get mic permissions, or a check of the mic permissions, has completed with a true or a false result  (will only be returned on iOS7 or later).*/
  
  func micPermissionCheckCompleted(withResult: Bool) {
    print("Local callback: mic check completed.")
  }

  
}

