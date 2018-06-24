//
//  PaymentMethodViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {
    
    @IBOutlet weak var creditCardNumber: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let lastFourCreditCardDigits = MobilicardUserDefaults.shared.defaults.string(forKey: "Last Four Numbers Of User Credit Card") {
            creditCardNumber.text = "**** **** **** \(lastFourCreditCardDigits)"
        }
    }
    
    @IBAction func removePaymentMethod(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Card removal", comment: ""), message: NSLocalizedString("Are You sure You want to remove the card?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Remove", comment: ""), style: .destructive, handler: { (action) in
            let innerAlert = UIAlertController(title: NSLocalizedString("Card removal", comment: ""), message: NSLocalizedString("Card removed succesfully", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            innerAlert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            MobilicardUserDefaults.shared.defaults.removeObject(forKey: "Last Four Numbers Of User Credit Card")
            MobilicardUserDefaults.shared.defaults.set(false, forKey: "User Set Payment Method")
            self.navigationController?.popViewController(animated: true)
            self.present(innerAlert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
