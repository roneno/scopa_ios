//
//  LoginViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class LoginRequestSMSViewController: UIViewController {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    var interactor: LoginInteractor?
    
    @IBAction func sendSMS(_ sender: UIButton) {
        interactor = LoginInteractor()
        if let phoneNumber = phoneNumber.text, phoneNumber.count >= 10 {
            self.interactor?.sendRequestForSMS(phoneNumber: phoneNumber)
            performSegue(withIdentifier: "showLoginVerifyOTP", sender: self)
        } else {
            notificationLabel.textColor = .red
            notificationLabel.text = "Please Enter a Valid Number"
            notificationLabel.textAlignment = .center
        }
    }
}

extension LoginRequestSMSViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
