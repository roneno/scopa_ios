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
    @IBAction func dissmissCardEnter(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPaymentMethod(_ sender: UIButton) {
        verifyPaymentMethod()
    }
    
    func verifyPaymentMethod() {
        isPaymentMethodEntered = true
        paymentMethodStatusText = "************3241"
        paymentMethodButtonStatusText = "Remove"
        dismiss(animated: true, completion: nil)
    }
}

extension PaymentMethodEnterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
