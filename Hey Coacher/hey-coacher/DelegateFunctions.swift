//
//  RootDelegateFunctions.swift
//  test-structure
//
//  Created by Andrew Li on 01/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights 


import CoreBluetooth

var currentViewControllerIdentifier: String?

protocol RootDelegate {
  func transitionTo(viewId: String, options: String)
  func connectRemote()
  func scanSensors()
  func stopScan()

}


extension RootViewController {
  
  func transitionTo(viewId: String, options: String ){
    print("Root delegated, switching container view")
    currentViewControllerIdentifier = viewId
    containerSwitchToViewController(viewId)
  }
  
  func connectRemote() {
    
    
    switch manager.state {
    case CBManagerState.poweredOn:
      speak("Looking for remote device")
      manager.scanForPeripherals(withServices: [REMOTE_SERVICE_UUID], options: nil)
      timeoutTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.scanRemoteTimeout), userInfo: nil, repeats: false)
      
    case CBManagerState.poweredOff:
      print("Bluetooth Status: Turned Off")
      speak("Bluetooth is currently switched off, please turn bluetooth on to connect")
      
    case CBManagerState.resetting:
      print("Bluetooth Status: Resetting")
      
    case CBManagerState.unauthorized:
      print("Bluetooth Status: Not Authorized")
      speak("Authorize bluetooth in privacy settings")
      
    case CBManagerState.unsupported:
      print("Bluetooth Status: Not Supported")
      speak("Bluetooth is not supported in this device")
      
    default:
      print("Bluetooth Status: Unknown")
    }

  }
  
  func scanRemoteTimeout() {
    manager.stopScan()
    speak("Unable to find device")
  }
  
  
  func scanSensors(){ 

    switch manager.state {
    case CBManagerState.poweredOn:
      speak("Searching for available sensors")
      timeoutTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.scanSensorTimeout), userInfo: nil, repeats: false)
      
    case CBManagerState.poweredOff:
      print("Bluetooth Status: Turned Off")
      speak("Bluetooth is currently switched off, please turn bluetooth on to connect")
      
    case CBManagerState.resetting:
      print("Bluetooth Status: Resetting")
      
    case CBManagerState.unauthorized:
      print("Bluetooth Status: Not Authorized")
      speak("Authorize bluetooth in privacy settings")
      
    case CBManagerState.unsupported:
      print("Bluetooth Status: Not Supported")
      speak("Bluetooth is not supported in this device")
      
    default:
      print("Bluetooth Status: Unknown")
    }
    
  } 
  
  func scanSensorTimeout() {
    manager.stopScan()
    speak("Unable to find any sensors")
  }
  
  func stopScan() {
    if self.timeoutTimer.isValid {
      self.timeoutTimer.invalidate()
      self.manager.stopScan()
    }
  }
  
}
