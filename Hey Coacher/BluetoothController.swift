//
//  BluetoothController.swift
//  Hey Coacher
//
//  Created by Andrew Li on 10/06/2017.
//  Copyright © 2017 imperial-smartbike. All rights reserved.
//

import CoreBluetooth

extension RootViewController {
  
  
  
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == CBManagerState.poweredOn {
      print("Bluetooth power on")
//      central.scanForPeripherals(withServices: nil, options: nil)
    } else {
      print("Bluetooth not available.")
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print("Discovered devices")
    let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
    
    if device?.contains(REMOTE_NAME) == true {
      print("Discovered custom remote device")
      self.manager.stopScan()
      self.timeoutTimer.invalidate()
    }
    
    self.remote = peripheral
    self.remote.delegate = self
    
    manager.connect(peripheral, options: nil)
    
  }
  
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected to custom remote device, seraching services")
    speak("Connected")
    peripheral.discoverServices(nil)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    for service in peripheral.services! {
      let thisService = service as CBService
      
      if service.uuid == REMOTE_SERVICE_UUID {
        print("Found gesture service, setting as thisService")
        peripheral.discoverCharacteristics(nil, for: thisService)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    for characteristic in service.characteristics! {
      let thisCharacteristic = characteristic as CBCharacteristic
      
      if thisCharacteristic.uuid == REMOTE_GESTURE_UUID {
        print("Found gesture characteristic, setting as thisCharacteristic")
        self.remote.setNotifyValue(true, for: thisCharacteristic)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    
    //    var val:UInt32 = 0;
    
    if characteristic.uuid == REMOTE_GESTURE_UUID {
      print("Remote value updated: \(characteristic.value!)")
      handleSignal(characteristic.value!)
    }
  }
  
  func handleSignal(_ byte: Data?){
    if (byte?.contains(1))!{
      print("Remote calls left tap")
      currentViewController?.handleAction(action: .tapLeft)
    }
    else if (byte?.contains(2))!{
      print("Remote calls right tap")
      currentViewController?.handleAction(action: .tapRight)
    }
    else if (byte?.contains(3))!{
      print("Remote calls left swipe")
      currentViewController?.handleAction(action: .swipeLeft)

    }
    else if (byte?.contains(4))!{
      print("Remote calls right swipe")
      currentViewController?.handleAction(action: .swipeRight)
    }
  }
  
  

}
