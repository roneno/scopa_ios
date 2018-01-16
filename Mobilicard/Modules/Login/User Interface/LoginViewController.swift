//
//  LoginViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    var navigation: LoginWireframe?
    
    @IBAction func sendSMS(_ sender: UIButton) {
        self.navigation?.presentHomeScreen()
    }
}
