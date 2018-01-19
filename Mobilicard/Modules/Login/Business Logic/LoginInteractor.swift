//
//  LoginInteractor.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

final class LoginInteractor: LoginInteractorProtocol {
    
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
            if let responce = responce {
                print(responce)
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            }.resume()
    }
    
    private struct Constants {
        static let requestSMSURL = "https://vend.mobilicard.com/pages/do_sms_request.php"
        static let applicationID = "!dneviliboM@"
    }
}
