//
//  ScanningViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class ScanningViewController: UIViewController {
    @IBOutlet var porgressView: UIView!
    var interactor: ScanningInteractor?
    var navigation: ScanningWireframe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = ScanningInteractor()
        self.interactor?.searchForScopos()
    }
    
    func handleNotFound() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
