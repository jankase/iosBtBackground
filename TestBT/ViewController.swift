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
import RxBluetoothKit
import RxSwift

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    _btManager = CBCentralManager(delegate: self,
//                                  queue: DispatchQueue(label: "BT"),
//                                  options: [CBCentralManagerOptionRestoreIdentifierKey: "eu.jkdev.bttestbtcentral"])
    _mainDisposeBag = DisposeBag()
    
    let theOptions: [String: AnyObject]
        = [CBCentralManagerOptionRestoreIdentifierKey: NSString(string: "eu.jkdev.bttestbtcentral")]
    _rxManager = BluetoothManager(queue: .main,
                                  options: theOptions)
    _rxManager.rx_state.subscribe(onNext: { [weak self] (aState: BluetoothState) in
          print("\(aState)")
          guard let theSelf: ViewController = self else {
            return
          }
          switch aState {
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
//            theSelf._rxManager.scanForPeripherals(withServices: nil).subscribe(onNext: {
//              guard let theName = $0.peripheral.name else {
//                return
//              }
//              print("\(theName) - \($0.peripheral.identifier.uuidString)")
//            })
              let theDeviceString = "114CA7C9-789B-4C33-8C4A-5E87105EE36F"
              theSelf._rxManager
                  .retrievePeripherals(withIdentifiers: [UUID(uuidString: theDeviceString)!])
                  .subscribe(onNext: { [weak self] (aPeripherals: [Peripheral]) in
                    guard let theSelf: ViewController = self else {
                      return
                    }
                    theSelf._rxPeripheral = aPeripherals.first!
                    theSelf._rxManager.connect(theSelf._rxPeripheral).subscribe(onNext: { [weak self] (aPeripheral: Peripheral) in
                          guard let theSelf: ViewController = self else {
                            return
                          }
                          aPeripheral.rx_isConnected.subscribe(onNext: {
                                print($0 ? "\(theDeviceString) connected" : "\(theDeviceString) disconnected")
                              }).addDisposableTo(theSelf._mainDisposeBag)
                        }).addDisposableTo(theSelf._mainDisposeBag)
                  }).addDisposableTo(theSelf._mainDisposeBag)
            
          }
        }).addDisposableTo(_mainDisposeBag)
  }
  
  //<CBPeripheral: 0x1700eec80, identifier = 0D3E9EA2-8EC8-47DA-A05E-5E2E2358A7FD, name = pLoFuAH1, state = disconnected>
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate var _btManager:      CBCentralManager! = nil
  fileprivate var _boxPeripheral:  CBPeripheral!     = nil
  fileprivate var _rxManager:      BluetoothManager! = nil
  fileprivate var _mainDisposeBag: DisposeBag!       = nil
  fileprivate var _rxPeripheral:   Peripheral!       = nil
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

