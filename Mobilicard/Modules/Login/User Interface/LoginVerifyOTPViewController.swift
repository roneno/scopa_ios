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
    
    @IBOutlet weak var resendSms: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer = Timer()
    
    var seconds = ConstantsGlobal.secondToEnableResendSMS
    
    var interactor: LoginInteractor?
    var navigation: LoginWireframe?
    
//    var responce: String?
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selector() {
        
        if seconds == 0 {
            timer.invalidate()
            resendSms.isEnabled = true
            activityIndicator.stopAnimating()
        } else {
            seconds -= 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginVerifyOTPViewController.selector), userInfo: nil, repeats: true)
        digitCodeField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
}

extension LoginVerifyOTPViewController: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        guard let digitCode = textField.text else { return }
        
        if digitCode.count == 5 {
            self.interactor = LoginInteractor()
            self.interactor?.loginDelegate = self
            self.interactor?.verifyOTP(otp: digitCode)
            
//            if responce == nil {
//                let homeViewController = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? UINavigationController
//            }
        }
    }
}

extension LoginVerifyOTPViewController: RequestResponceDelegate {
    func getResponceMessage(responceMessage: String, errorNumber: Bool) {
        print(responceMessage, errorNumber)
        
        if !errorNumber {
            DispatchQueue.main.async {
                let homeViewController = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? UINavigationController
                self.present(homeViewController!, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
            let alert = UIAlertController(title: "Invalid Code", message: "Please try again or resend code request", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
}













