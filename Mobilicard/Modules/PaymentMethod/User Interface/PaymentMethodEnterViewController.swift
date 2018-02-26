//
//  PaymentMethodCardsViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/24/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class PaymentMethodEnterViewController: UIViewController {
    
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    var interactor: PaymentMethodInteractor?
    
    
    @IBAction func addPaymentMethod(_ sender: UIButton) {
        isValidData()
        interactor = PaymentMethodInteractor()
        self.interactor?.delegate = self
        interactor?.verifyPaymentMethod()
    }
    
    func isValidData() {
        if let cardNumber = cardNumber.text, cardNumber.count <= 16,
            let cvv = cvv.text, cvv.count <= 5,
            let expirationDate = expirationDate.text, expirationDate.count <= 4,
            let lastName = lastName.text, lastName.count > 0,
            let firstName = firstName.text, firstName.count > 0 {
            MobilicardUserDefaults.shared.defaults.set(true, forKey: "User Added Payment Method")
            MobilicardUserDefaults.shared.defaults.set(cardNumber, forKey: "User's Card Number")
            MobilicardUserDefaults.shared.defaults.set(cardNumber.suffix(4), forKey: "User's Last Four Card Number Digits")
            MobilicardUserDefaults.shared.defaults.set(expirationDate, forKey: "User's Card Expiration Date")
            MobilicardUserDefaults.shared.defaults.set(cvv, forKey: "User's Card Cvv")
            MobilicardUserDefaults.shared.defaults.set(firstName, forKey: "User's Card First Name")
            MobilicardUserDefaults.shared.defaults.set(lastName, forKey: "User's Card Last Name")
        } else {
            let alert = UIAlertController(title: "Input error", message: "Please check card data", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PaymentMethodEnterViewController: PaymentMethodDelegate {
    func paymentMethodVerificationResponce(responceError: Int, responceStatus: String, responceMessage: String) {
        print(responceError)
        print(responceStatus)
        print(responceMessage)
        if responceError == 0 {
            DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Something Wrong", message: "Please check Your card details", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
