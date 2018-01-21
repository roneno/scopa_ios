//
//  LoginVerifyOTPViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/19/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class LoginVerifyOTPViewController: UIViewController {
    
    @IBOutlet weak var digitCodeField: UITextField!
    
    var interactor: LoginInteractor?
    var navigation: LoginWireframe?
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        digitCodeField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
}

extension LoginVerifyOTPViewController: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        guard let digitCode = textField.text else { return }
        
        if digitCode.count == 5 {
            self.interactor = LoginInteractor()
            self.interactor?.verifyOTP(otp: Int(digitCode)!)
            
            //TODO: make navigation logic
            let homeViewController = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            present(homeViewController!, animated: true, completion: nil)
        }
    }
}
