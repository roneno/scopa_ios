//
//  LoginViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    var navigation: LoginWireframe?
    var interactor: LoginInteractor?
    
    @IBAction func sendSMS(_ sender: UIButton) {
        interactor = LoginInteractor()
        if let phoneNumber = phoneNumber.text{
            self.interactor?.sendRequestForSMS(phoneNumber: phoneNumber)
        }
//        self.navigation?.presentHomeScreen()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
