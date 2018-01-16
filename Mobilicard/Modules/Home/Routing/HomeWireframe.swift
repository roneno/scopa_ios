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
        
        let scanningViewController = UIStoryboard.init(name: Constants.scanningStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.scanningStoryboardIdentifier)
        
        self.homeScreenViewController?.present(scanningViewController, animated: true, completion: nil)
    }
    
    private struct Constants {
        static let scanningStoryboardName = "Scanning"
        static let scanningStoryboardIdentifier = "ScanningViewController"
    }
}
