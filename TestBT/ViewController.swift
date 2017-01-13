//
//  ViewController.swift
//  TestBT
//
//  Created by Jan Kase on 13.01.17.
//  Copyright © 2017 Jan Kase. All rights reserved.
//

import UIKit
import CoreBluetooth
import Dispatch

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _btManage = CBCentralManager(delegate: self,
                                 queue: DispatchQueue(label: "BT"),
                                 options: [CBCentralManagerOptionRestoreIdentifierKey: "eu.jkdev.bttestbtcentral"])
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate var _btManage:      CBCentralManager! = nil
  fileprivate var _boxPeripheral: CBPeripheral!     = nil
  // pokud není uloženo tak vrací misuse api a nefunguje
  
}

extension ViewController: CBCentralManagerDelegate {
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    print("\(central.state)")
    switch central.state {
      case .unknown:
        print("state unknown")
      case .resetting:
        print("state resetting")
      case .unsupported:
        print("state unsupported")
      case .unauthorized:
        print("state unauthorized")
      case .poweredOff:
        print("state powered off")
      case .poweredOn:
        print("state powered on")
        _boxPeripheral
        = central.retrievePeripherals(withIdentifiers: [UUID(uuidString: "B92BC8DF-350D-4F70-922C-845A59A935F5")!]).first!
        central.connect(_boxPeripheral)
      
    }
  }
  
  // pokud se zpracování události nevejde do 10s, je nutno startovat background task
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("connected to box")
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print("disconnected from box")
  }
  
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
    print("restore of bt")
    print("\(dict)")
  }
  
}

