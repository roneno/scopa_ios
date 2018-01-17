//
//  ScanningInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation
import CoreBluetooth

final class ScanningInteractor: NSObject, ScanningInteractorProtocol {
    
    var centralManager: CBCentralManager?
    var peripherals = Array<CBPeripheral>()
    
    func searchForScopos() {
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
}

extension ScanningInteractor: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
        print(peripheral)
    }
}
