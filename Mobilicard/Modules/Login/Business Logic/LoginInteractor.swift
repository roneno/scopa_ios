//
//  LoginInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

protocol RequestResponceDelegate: class {
    func getResponceMessage(responceMessage: String, errorNumber: Int)
}

final class LoginInteractor: LoginInteractorProtocol {
    
    
    weak var loginDelegate: RequestResponceDelegate?
    
    func sendRequestForSMS(phoneNumber: String) {
        
        guard let requestSMSURL = URL(string: Constants.requestSMSURL) else { return }
        
        let parameters = ["password" : Constants.applicationID, "mobile_number": phoneNumber]
        var request = URLRequest(url: requestSMSURL)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            
//            guard let data = data else { return }
//            do {
//                let serverResponce = try JSONDecoder().decode(RequestSMSResponce.self, from: data)
//
//            } catch {
//                print(error.localizedDescription)
//            }
            }.resume()
    }
    
    func verifyOTP(otp: String){
        
        guard let verifyOTPURL = URL(string: Constants.verifyOTPURL) else { return }
        
        let parameters = ["otp" : String(otp), "password" : Constants.applicationID]
        var request = URLRequest(url: verifyOTPURL)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let hhtpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = hhtpBody
        
        print(parameters)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in

            guard let data = data else { return }
            do {
                
                let serverResponce = try JSONDecoder().decode(VerifySMSResponce.self, from: data)
                
                    if let responceMessage = serverResponce.message,
                        let errorMessage = serverResponce.error {
                        self.loginDelegate?.getResponceMessage(responceMessage: responceMessage, errorNumber: errorMessage)
                }
            }
            catch {
                self.loginDelegate?.getResponceMessage(responceMessage: error.localizedDescription, errorNumber: -1)
            }
            }.resume()
    }
    
    private struct RequestSMSResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct VerifySMSResponce: Decodable {
        var error: Int?
        var message: String?
    }
    
    private struct Constants {
        static let requestSMSURL = "https://vend.mobilicard.com/pages/do_sms_request.php"
        static let verifyOTPURL = "https://vend.mobilicard.com/pages/verify_otp.php"
        static let applicationID = "!dneviliboM@"
    }
}
