//
//  ViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var navigation: HomeWireframe?
    var showHideTapped = false
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadingConstraint.constant = -220
    }
    
    @IBAction func showHideSidebarMenu(_ sender: UIButton) {
        
        if showHideTapped {
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraint.constant -= 220
            self.view.layoutIfNeeded()
        }
            showHideTapped = !showHideTapped
        } else {
            UIView.animate(withDuration: 0.5) {
                self.leadingConstraint.constant += 220
                self.view.layoutIfNeeded()
            }
            showHideTapped = !showHideTapped
        }
    }

    @IBAction func showPaymentScreen(_ sender: UIButton) {
        self.navigation = HomeWireframe()
        self.navigation?.homeScreenViewController = self
        self.navigation?.presentPaymentScreen()
    }
    @IBAction func searchDevice(_ sender: UIButton) {
        
        if isPaymentMethodEntered {
        self.navigation = HomeWireframe()
        self.navigation?.homeScreenViewController = self
        self.navigation?.presentScanningScreen()
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Payment metod not set", message: "Please add payment method", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Set Payment Method", style: .destructive, handler: { (action) in
            self.goToPayment()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToPayment() {
        self.navigation = HomeWireframe()
        self.navigation?.homeScreenViewController = self
        self.navigation?.presentPaymentScreen()
    }
}

