//
//  ScanningInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation
import CoreBluetooth

var peripherals: CBPeripheral?

final class ScanningInteractor: NSObject, ScanningInteractorProtocol {
    
    var centralManager: CBCentralManager?
//    var peripherals = Array<CBPeripheral>()
    
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
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Scopos"{
            peripherals = peripheral
        print(peripherals!)
            centralManager?.stopScan()
        }

    }
}
