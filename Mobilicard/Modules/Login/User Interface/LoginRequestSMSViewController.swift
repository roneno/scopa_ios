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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let mobileValue = MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number") {
        print(mobileValue)
        }
    }
    
    @IBAction func sendSMS(_ sender: UIButton) {
        interactor = LoginInteractor()
        if let phoneNumber = phoneNumber.text, phoneNumber.count >= 10, phoneNumber.count <= 12 {
            MobilicardUserDefaults.shared.defaults.set(String(phoneNumber), forKey: "User's Mobile Number")
            self.interactor?.sendRequestForSMS(phoneNumber: phoneNumber)
            performSegue(withIdentifier: "showLoginVerifyOTP", sender: self)
        } else {
            notificationLabel.textColor = .red
            notificationLabel.text = NSLocalizedString("Please Enter a Valid Number", comment: "")
            notificationLabel.textAlignment = .center
        }
    }
}

extension LoginRequestSMSViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
