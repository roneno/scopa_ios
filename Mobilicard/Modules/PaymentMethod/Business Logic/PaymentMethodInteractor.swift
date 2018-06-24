//
//  PaymentMethodInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

protocol PaymentMethodDelegate {
    func paymentMethodVerificationResponce(title: String, responceStatus: String, success: Bool)
}

class PaymentMethodInteractor {
    
    var delegate: PaymentMethodDelegate?
    
    func verifyPaymentMethod(cardNumber: String, expirationDate: String, cvv: String, firstName: String, lastName: String) {
        
        guard let verifyPaymentMethodUrl = URL(string: Constants.cardRegistrationUrl) else { return }
        
        print(MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number")!)
        print(cvv, cardNumber, expirationDate, firstName, lastName)
        
        let parameters = ["password" : Constants.applicationID,
                          "operator_id": "0000",
                          "mobile_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number")!,
                          "card_number" : cardNumber,
                          "expiration_date" : expirationDate,
                          "cvv" : cvv,
                          "first_name" : firstName,
                          "last_name" : lastName
        ]
        var request = URLRequest(url: verifyPaymentMethodUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifyPaymentMethodResponce.self, from: data)
                
                if serverResponce.status == "036" {
                    let title = NSLocalizedString("Card Registration Failed", comment: "")
                    let messege = NSLocalizedString("Please check Exp Date and try again", comment: "")
                    self.delegate?.paymentMethodVerificationResponce(title: title, responceStatus: messege, success: false)
                } else if serverResponce.status == "039" || serverResponce.status == "033" {
                    let title = NSLocalizedString("Card Registration Failed", comment: "")
                    let messege = NSLocalizedString("Problem in card registration", comment: "")
                    self.delegate?.paymentMethodVerificationResponce(title: title, responceStatus: messege, success: false)
                } else {
                    MobilicardUserDefaults.shared.defaults.set(String(cardNumber.suffix(4)), forKey: "Last Four Numbers Of User Credit Card")
                    self.delegate?.paymentMethodVerificationResponce(title: NSLocalizedString("Success", comment: ""), responceStatus: NSLocalizedString("Card registration successful", comment: ""), success: true)
                }
            }
            catch let error{
                print(error)
            }
            }.resume()
    }
    
    private struct VerifyPaymentMethodResponce: Decodable {
        var error: Bool?
        var message: String?
        var status: String?
        var token: String?
        var expdate: String?
    }
    
    private struct Constants {
        static let cardRegistrationUrl = "https://vend.mobilicard.com/pages/do_card_registration.php"
        static let applicationID = "!dneviliboM@"
    }
}
