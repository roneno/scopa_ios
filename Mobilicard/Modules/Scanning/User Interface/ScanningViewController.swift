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
        if peripherals != nil {
            showAlert()
        }
    }
    
    var counter:Int = 20 {
        didSet {
            if counter == 0 {
                dismiss(animated: true, completion: nil)
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
