//
//  ScanningViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class ScanningViewController: UIViewController {
    var interactor: ScanningInteractor?
    var navigation: ScanningWireframe?
    
    var fractionalProgress:Float = 0
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        runTimer()
        search()
    }
    
    var counter:Int = 20 {
        didSet {
            if counter == 0 {
                self.navigationController?.popViewController(animated: true)
            }
            fractionalProgress += 0.05
            progressView.setProgress(fractionalProgress, animated: true)
        }
    }
    
    var timer = Timer()
    
    @objc func updateTimer() {
        counter -= 1
    }
    
    func runTimer() {
        if counter != 0 {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    func search() {
        self.interactor = ScanningInteractor()
        self.interactor?.delegate = self
        self.interactor?.searchForScopos()
    }
    
    func showPaymentConfirmationAlert() {
        let alert = UIAlertController(title: "Payment Confirmation", message: "Do You approve payment to machine number ", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Approve", style: .destructive, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNotFound() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ScanningViewController: ScanningInterectorDelegate {
    func didPaymentAproovmentResponce(errorNumber: Int, serverResponce: String) {
        //Handle
    }
    
    func didFoundScopos() {
        DispatchQueue.main.async {
            self.showPaymentConfirmationAlert()
        }
    }
    
    
}
