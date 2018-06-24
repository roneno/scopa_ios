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
    func didPaymentAproovmentResponce(errorNumber: Bool,serverResponce: String)
    func paymentApprovemetnRequest(operatorType: String, operatorId: String, machineType: String, machineId: String , cyclePrice: String)
    func statusToShowInAlert(message: String?)
    func customUserAlert()
    func showUserNeedToSetPaymentMethodAlert()
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
    
    func paymentApprovment(cyclePrice: String, operatorId: String, machineType: String, machineId: String) {
        
        guard let paymentApprovmentUrl = URL(string: Constants.paymentAproovmentUrl) else { return }
        
        var handledOperatorId = ""
        
        switch operatorId.count {
        case 1:
            handledOperatorId = "000" + operatorId
        case 2:
            handledOperatorId = "00" + operatorId
        case 3:
            handledOperatorId = "0" + operatorId
        default:
            break
        }
        
        print(handledOperatorId)
        
        let parameters = [
            "password" : Constants.applicationID,
            "mobile_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number"),
            "machine_id" : machineId,
            "machine_type" : machineType,
            "operator_id" : handledOperatorId,
            "cycle_price" : cyclePrice
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
                
                print(serverResponce.message)
                
                self.delegate?.didPaymentAproovmentResponce(errorNumber: serverResponce.error!, serverResponce: serverResponce.message!)
                
                
                if self.remotePeripheral.first?.state == .connected {
                    if let dataToWrite = ConstantsGlobal.opCode.data(using: .utf8) {
                        self.remotePeripheral.first?.writeValue(dataToWrite, for: self.remoteCharacteristic!, type: .withResponse)
                    }
                }
                
                print(serverResponce.error!, serverResponce.message!)
            }
            catch let error {
                print("Error: \(error)")
            }
            }.resume()
    }
    
    
    private struct VerifyPaymentResponce: Decodable {
        var error: Bool?
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
            peripheral.delegate = self
            self.remotePeripheral.append(peripheral)
            centralManager?.stopScan()
            centralManager?.connect(peripheral, options: nil)
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
        
        if let serviceArray = peripheral.services, serviceArray.isEmpty {
            delegate?.statusToShowInAlert(message: NSLocalizedString("No MPS Service", comment: ""))
        }
        
        if let mpsService = peripheral.services?.first {
            let characteristics = CBUUID(string: "6e400007-b5a3-f393-e0a9-e50e24dcca9e")
            peripheral.discoverCharacteristics([characteristics], for: mpsService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            print("error = \(error)")
            return
        }
        
        if let arrayOfSevices = service.characteristics, arrayOfSevices.isEmpty {
            delegate?.statusToShowInAlert(message: NSLocalizedString("Error: No Values", comment: ""))
        } else {
            let machineDataCharecteristic = (service.characteristics?.first)!
            remoteCharacteristic = machineDataCharecteristic
            peripheral.setNotifyValue(true, for: machineDataCharecteristic)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let e = error {
            print("ERROR didUpdateValue \(e)")
            return
        }
        guard let data = characteristic.value else { return }
        
        let operatorType = reverseDataAndGetDecimalValue(data: data, getBytes: [0, 1, 2, 3])
        let operatorId = reverseDataAndGetDecimalValue(data: data, getBytes: [4, 5, 6, 7])
        let machineType =  reverseDataAndGetDecimalValue(data: data, getBytes: [8, 9, 10, 11])
        let machineId = reverseDataAndGetDecimalValue(data: data, getBytes: [12, 13, 14, 15])
        let machinePrice = reverseDataAndGetDecimalValue(data: data, getBytes: [16, 17, 18, 19])
        
        MobilicardUserDefaults.shared.defaults.set(operatorId, forKey: "Operator id")
        
        if MobilicardUserDefaults.shared.defaults.bool(forKey: "User Set Payment Method") {
            delegate?.paymentApprovemetnRequest(operatorType: operatorType, operatorId: operatorId, machineType: machineType, machineId: machineId, cyclePrice: machinePrice)
        } else {
            disconnectFromScopos()
            delegate?.showUserNeedToSetPaymentMethodAlert()
        }
        
//                paymentApprovment(dataFromScopos: )
        //        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    private func reverseDataAndGetDecimalValue(data: Data, getBytes: [Int]) -> String {
        var reversedData = Data()
        for reversedIndex in getBytes.reversed() {
            reversedData.append(Data(bytes: [data[reversedIndex]]))
        }
        return String(Int(reversedData.hexEncodedString(), radix: 16)!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            
        }
        centralManager?.cancelPeripheralConnection(peripheral)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        delegate?.customUserAlert()
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

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

}
