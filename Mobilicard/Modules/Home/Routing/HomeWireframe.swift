//
//  HomeWireframe.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class HomeWireframe: HomeWireframeProtocol {
    
    static let sharedInstance = HomeWireframe()
    fileprivate init() {}
    
    var homeViewController: HomeViewController?
    var homeScreenViewController: UINavigationController?
    
    var window: UIWindow?
    
    func presentScanningScreen() {
        
        let scanningViewController = UIStoryboard.init(name: Constants.scanningStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.scanningStoryboardIdentifier) as? ScanningViewController
        
        self.homeViewController?.navigationController?.pushViewController(scanningViewController!, animated: true)
//        self.homeScreenViewController?.present(scanningViewController!, animated: true, completion: nil)
    }
    
    func presentPaymentScreen() {
        let paymentViewController = UIStoryboard.init(name: Constants.paymentStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.paymentStoryboardIdentifier)
        
        self.homeViewController?.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
    func presentRemovePaymentMethodScreen() {
        let paymentViewController = UIStoryboard.init(name: Constants.paymentStoryboardName, bundle: nil).instantiateViewController(withIdentifier: "RemovePaymentMethodViewController")
        
        self.homeViewController?.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
    func presentHomeScreenViewControllerInWindow() {
        let homeScreenViewController = UIStoryboard.init(name: Constants.homeStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.homeStoryboardIdentifier) as? UINavigationController
        self.homeScreenViewController = homeScreenViewController
//        self.loginScreenVerificationViewController?.navigation = self
        self.window?.rootViewController = homeScreenViewController
        self.window?.makeKeyAndVisible()
    }
    
    private struct Constants {
        static let scanningStoryboardName = "Scanning"
        static let scanningStoryboardIdentifier = "ScanningViewController"
        static let paymentStoryboardName = "PaymentMethod"
        static let paymentStoryboardIdentifier = "NoPaymentMethodViewController"
        static let homeStoryboardName = "Home"
        static let homeStoryboardIdentifier = "HomeViewController"
    }
}
