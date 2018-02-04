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
    func didFoundScopos()
}

var peripherals: CBPeripheral?

final class ScanningInteractor: NSObject, ScanningInteractorProtocol {
    
    var delegate: ScanningInterectorDelegate?
    
    var centralManager: CBCentralManager?
    
    func searchForScopos() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func paymentApprovment() {
        
        guard let paymentApprovmentUrl = URL(string: Constants.paymentAproovmentUrl) else { return }
        
        let parameters = ["password" : Constants.applicationID,
                          "mobile_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile NUmber"),
                          "machine_id" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Number"),
                          "machine_type" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Expiration Date"),
                          "operator" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Cvv"),
                          "operator_id" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card First Name"),
                          "cycle_price" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Last Name")]
        var request = URLRequest(url: paymentApprovmentUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifyPaymentMethodResponce.self, from: data)
                
                self.delegate?.didPaymentAproovmentResponce(errorNumber: serverResponce.error!, serverResponce: serverResponce.message!)
            }
            catch {
            }
            }.resume()
    }
    
    private struct VerifyPaymentMethodResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct Constants {
        static let paymentAproovmentUrl = "https://vend.mobilicard.com/pages/do_payment.php"
        static let applicationID = "!dneviliboM@"
    }
    
}

extension ScanningInteractor: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != "scopos"{
            print(peripheral.readRSSI())
            print(peripheral)
            centralManager?.stopScan()
            delegate?.didFoundScopos()
        }

    }
}
