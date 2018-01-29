//
//  HomeWireframe.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class HomeWireframe: HomeWireframeProtocol {
    
    var homeScreenViewController: HomeViewController?
    
    func presentScanningScreen() {
        
        let scanningViewController = UIStoryboard.init(name: Constants.scanningStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.scanningStoryboardIdentifier) as? ScanningViewController
        
        self.homeScreenViewController?.present(scanningViewController!, animated: true, completion: nil)
    }
    
    func presentPaymentScreen() {
        let paymentViewController = UIStoryboard.init(name: Constants.paymentStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.paymentStoryboardIdentifier) as? PaymentMethodViewController
        
        self.homeScreenViewController?.present(paymentViewController!, animated: true, completion: nil)
    }
    
    
    private struct Constants {
        static let scanningStoryboardName = "Scanning"
        static let scanningStoryboardIdentifier = "ScanningViewController"
        static let paymentStoryboardName = "PaymentMethod"
        static let paymentStoryboardIdentifier = "PaymentMethodViewController"
    }
}
