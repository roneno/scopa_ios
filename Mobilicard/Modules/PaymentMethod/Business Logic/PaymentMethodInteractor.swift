//
//  PaymentMethodInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

protocol PaymentMethodDelegate {
    func paymentMethodVerificationResponce(responceError: Int, responceStatus: String, responceMessage: String )
}

class PaymentMethodInteractor {
    
    var delegate: PaymentMethodDelegate?
    
    func verifyPaymentMethod() {
        
        guard let verifyPaymentMethodUrl = URL(string: Constants.cardRegistrationUrl) else { return }
        
        let parameters = ["password" : Constants.applicationID,
                          "mobile_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number")!,
                          "card_number" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Number")!,
                          "expiration_date" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Expiration Date")!,
                          "cvv" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Cvv")!,
                          "first_name" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card First Name")!,
                          "last_name" : MobilicardUserDefaults.shared.defaults.string(forKey: "User's Card Last Name")!
        ]
        var request = URLRequest(url: verifyPaymentMethodUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        print(parameters)
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifyPaymentMethodResponce.self, from: data)

                self.delegate?.paymentMethodVerificationResponce(responceError: serverResponce.error!, responceStatus: serverResponce.status!, responceMessage: serverResponce.message!)
            }
            catch {
            }
            }.resume()
    }
    
    private struct VerifyPaymentMethodResponce: Decodable {
        var error: Int?
        var message: String?
        var status: String?
    }
    
    private struct Constants {
        static let cardRegistrationUrl = "https://vend.mobilicard.com/pages/do_card_registration.php"
        static let applicationID = "!dneviliboM@"
    }
}
