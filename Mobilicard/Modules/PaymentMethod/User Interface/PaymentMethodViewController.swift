//
//  PaymentMethodViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {
    
    @IBOutlet weak var paymentMethodStatus: UILabel!
    @IBOutlet weak var addRemoveButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let lastFourCreditCardDigits = MobilicardUserDefaults.shared.defaults.string(forKey: "User's Last Four Card Number Digits") {
            paymentMethodStatus.text = "**** **** **** \(lastFourCreditCardDigits)"
        }
    }
    
    
}
