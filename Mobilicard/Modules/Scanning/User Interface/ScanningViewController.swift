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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        search()
        if peripherals != nil {
            showAlert()
        }
    }
    
    func search() {
        self.interactor = ScanningInteractor()
        self.interactor?.searchForScopos()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Found Scopos", message: "Found \(peripherals?.name! ?? "not found"), ID \(String(describing: peripherals?.identifier) )", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNotFound() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //TODO: add navigation
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
