//
//  ScanningInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol ScanningInterectorDelegate {
    func didPaymentAproovmentResponce(errorNumber: Int ,serverResponce: String)
    func paymentApprovemetnRequest(dataFromScopos: String)
    func statusToShowInAlert(message: String?)
}

final class ScanningInteractor: NSObject, ScanningInteractorProtocol {
    
    var delegate: ScanningInterectorDelegate?
    
    var remotePeripheral = [CBPeripheral]()
    
    var remoteCharacteristic: CBCharacteristic?
    
    var centralManager: CBCentralManager?
    
    func searchForScopos() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func disconnectFromScopos() {
        self.centralManager?.cancelPeripheralConnection(remotePeripheral.first!)
    }
    
    func paymentApprovment(dataFromScopos: String) {
        
        guard let paymentApprovmentUrl = URL(string: Constants.paymentAproovmentUrl) else { return }
        
        let parameters = [
            "password" : "!dneviliboM@",
            "mobile_number" : "0542323420",
            "machine_id" : "5000",
            "machine_type" : "01",
            "operator_id" : "0000",
            "cycle_price": "0001"
            
            //            "password" : Constants.applicationID,
            //            "mobile_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number"),
            //            "machine_id" : dataFromScopos[6..<10],
            //            "machine_type" : dataFromScopos[4..<6],
            //            "operator" : "woodhill",
            //            "operator_id" : dataFromScopos[0..<4],
            //            "cycle_price" : dataFromScopos[10..<14]
        ]
        var request = URLRequest(url: paymentApprovmentUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifyPaymentResponce.self, from: data)
                
                self.delegate?.didPaymentAproovmentResponce(errorNumber: serverResponce.error!, serverResponce: serverResponce.message!)
                
                let stringToScopos = "19081965"
                if let dataToScopos = stringToScopos.data(using: String.Encoding.utf8) {
                    self.remotePeripheral.first?.writeValue(dataToScopos, for: self.remoteCharacteristic!, type: .withResponse)
                }
                
                print(serverResponce.error!, serverResponce.message!)
            }
            catch {
            }
            }.resume()
    }
    
    private struct VerifyPaymentResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct Constants {
        static let paymentAproovmentUrl = "https://vend.mobilicard.com/pages/do_payment.php"
        static let applicationID = "!dneviliboM@"
    }
    
}

extension ScanningInteractor: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state.rawValue)
        if (central.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "scopos"{
            print(peripheral)
            peripheral.delegate = self
            self.remotePeripheral.append(peripheral)
            centralManager?.connect(peripheral, options: nil)
            centralManager?.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        let serviceUUID = CBUUID(string: "6e400005-b5a3-f393-e0a9-e50e24dcca9e")
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("error = \(error)")
            return
        }
        for service in peripheral.services! {
            let characteristics = CBUUID(string: "6e400007-b5a3-f393-e0a9-e50e24dcca9e")
            let writeCharacteristic = CBUUID(string:"6e400006-b5a3-f393-e0a9-e50e24dcca9e")
            peripheral.discoverCharacteristics([characteristics, writeCharacteristic], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let charesteristic = service.characteristics?.first {
            peripheral.readValue(for: charesteristic)
        }
        if let characterictic = service.characteristics?.last {
            remoteCharacteristic = characterictic
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            print("ERROR didUpdateValue \(e)")
            return
        }
        guard let data = characteristic.value else { return }
        let stringData = String(decoding: data, as: UTF8.self)
        delegate?.paymentApprovemetnRequest(dataFromScopos: stringData)
        //        paymentApprovment(dataFromScopos: stringData)
        //        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            
        }
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        //        delegate?.bleDisconnected()
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}
