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
        //        self.interactor?.paymentApprovment(dataFromScopos: "g")
        self.interactor?.searchForScopos()
//        self.interactor?.paymentApprovment(cyclePrice: String, operatorId: String, machineType: String, machineId: String, dataFromScopos: "123")
    }
    
    func customUserMessageAllert(message: String?, err: Bool) {
        
        if err {
            if let errorMessage = message, errorMessage == "Scopos Was Disconnected" {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message:NSLocalizedString("Scropos Was Disconnected", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Error Payment", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Payment Was Successful", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showPaymentConfirmationAlert(operatorType: String, operatorId: String, machineType: String, machineId: String , cyclePrice: String) {
        
        let alert = UIAlertController(title: NSLocalizedString("Payment Confirmation", comment: ""), message: NSLocalizedString("Do You accept Payment of \(handlePrice(cyclePrice: cyclePrice))", comment: "String showing to user"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)
            self.interactor?.disconnectFromScopos()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Approve", comment: ""), style: .destructive, handler: {(alert: UIAlertAction!) in
            self.interactor?.paymentApprovment(cyclePrice: cyclePrice, operatorId: operatorId, machineType: machineType, machineId: machineId)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleNotFound() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handlePrice(cyclePrice: String) -> String {
        var cyclePrice = cyclePrice
        if cyclePrice.count <= 2 {
            return "nis: 00, cents: \(cyclePrice)"
        } else {
            let endIndex = cyclePrice.index(cyclePrice.endIndex, offsetBy: -2)
            let truncated = cyclePrice.substring(to: endIndex)
            return "nis: \(truncated), cents: \(cyclePrice.removeLast(2))"
        }
    }
    
}

extension ScanningViewController: ScanningInterectorDelegate {
    
    func showUserNeedToSetPaymentMethodAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("Payment metod not set", comment: ""), message: NSLocalizedString("Please add payment method", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Not now", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
                let innerAlert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You need to enter valid payment method", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                innerAlert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (action) in
                    exit(0)
                }))
                self.present(innerAlert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Set now", comment: ""), style: .destructive, handler: { (action) in
                let paymentViewController = UIStoryboard.init(name: "PaymentMethod", bundle: nil).instantiateViewController(withIdentifier: "PaymentMethodEnterViewController")
                
                self.present(paymentViewController, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func paymentApprovemetnRequest(operatorType: String, operatorId: String, machineType: String, machineId: String , cyclePrice: String) {
        
        DispatchQueue.main.async {
            self.showPaymentConfirmationAlert(operatorType: operatorType, operatorId: operatorId, machineType: machineType, machineId: machineId, cyclePrice: cyclePrice)
        }
    }
    
    func didPaymentAproovmentResponce(errorNumber: Bool, serverResponce: String) {
            DispatchQueue.main.async {
                self.customUserMessageAllert(message: serverResponce, err: errorNumber)
            }
    }
    
    //Use or Delete
    func statusToShowInAlert(message: String?) {
        DispatchQueue.main.async {
//            self.customUserMessageAllert(message: message, err: )
        }
    }
    
    
}
