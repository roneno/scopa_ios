//
//  LoginInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

final class LoginInteractor: LoginInteractorProtocol {
    
    func sendRequestForSMS(phoneNumber: String) -> String? {
        
        var requestSMSResponse: String?
        
        guard let requestSMSURL = URL(string: Constants.requestSMSURL) else { return  nil}
        
        let parameters = ["password" : Constants.applicationID, "mobile_number": phoneNumber]
        var request = URLRequest(url: requestSMSURL)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return nil }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
            guard let data = data else { return }
            do {
                let serverResponce = try JSONDecoder().decode(RequestSMSResponce.self, from: data)
                
                requestSMSResponse = serverResponce.message
            } catch {
                requestSMSResponse = error.localizedDescription
            }
            }.resume()
        
        return requestSMSResponse
    }
    
    func verifyOTP(otp: Int) -> String? {
        
        var verifyOTPResponce: String?
        
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
                
                let serverResponce = try JSONDecoder().decode(VerifySMSResponce.self, from: data)
                
                DispatchQueue.main.async {
                verifyOTPResponce = serverResponce.message
                }
            }
            catch {
                verifyOTPResponce = error.localizedDescription
            }
            }.resume()
        
        return verifyOTPResponce
    }
    
    private struct RequestSMSResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct VerifySMSResponce: Decodable {
        var error: Int?
        var message: String?
        var mobile: Int?
    }
    
    private struct Constants {
        static let requestSMSURL = "https://vend.mobilicard.com/pages/do_sms_request.php"
        static let verifyOTPURL = "https://vend.mobilicard.com/pages/verify_otp.php"
        static let applicationID = "!dneviliboM@"
    }
}
