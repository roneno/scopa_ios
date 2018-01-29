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
    @IBAction func goHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        paymentMethodStatus.text = paymentMethodStatusText
        addRemoveButton.titleLabel?.text = paymentMethodButtonStatusText
    }
    

}
