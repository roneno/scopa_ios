//
//  PaymentMethodInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

class PaymentMethodInteractor {
    func verifyPaymentMethod(otp: Int) -> String? {
        
        var verifyPaymentMethodResponce: String?
        
        guard let verifyOTPURL = URL(string: Constants.verifyOTPURL) else { return nil }
        
        let parameters = ["otp" : otp]
        var request = URLRequest(url: verifyOTPURL)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return nil}
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifyPaymentMethodResponce.self, from: data)
                
                DispatchQueue.main.async {
                    verifyPaymentMethodResponce = serverResponce.message
                }
            }
            catch {
                verifyPaymentMethodResponce = error.localizedDescription
            }
            }.resume()
        
        return verifyPaymentMethodResponce
    }
    
    private struct VerifyPaymentMethodResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct Constants {
        static let requestSMSURL = "https://vend.mobilicard.com/pages/do_sms_request.php"
        static let verifyOTPURL = "https://vend.mobilicard.com/pages/verify_otp.php"
        static let applicationID = "!dneviliboM@"
    }
}
