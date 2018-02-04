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
    
    @IBOutlet weak var scanningButton: UIButton!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func paymentHistory(_ sender: UIButton) {
        let alert = UIAlertController(title: "Payment history", message: "This feature is comming soon", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showHideSidebarMenu(_ sender: UIButton) {
        
        if showHideTapped {
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraint.constant -= 220
            self.scanningButton.alpha = 1
            self.view.layoutIfNeeded()
        }
            showHideTapped = !showHideTapped
        } else {
            UIView.animate(withDuration: 0.5) {
                self.scanningButton.alpha = 0
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
        
        if MobilicardUserDefaults.shared.defaults.bool(forKey: "User Added Payment Method") {
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

public enum ButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: ButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

