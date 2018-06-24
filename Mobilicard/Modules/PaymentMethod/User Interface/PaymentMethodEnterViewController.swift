//
//  PaymentMethodCardsViewController.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/24/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class PaymentMethodEnterViewController: UIViewController {
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    var interactor: PaymentMethodInteractor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumber.delegate = self
        cvv.delegate = self
        expirationDate.delegate = self
    }
    
    @IBAction func goToHomeScreen(_ sender: UIButton) {
        let homeViewController = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        self.present(homeViewController, animated: true, completion: nil)
    }
    @IBAction func addPaymentMethod(_ sender: UIButton) {
        isValidData()
    }
    
    
    func isValidData() {
        if let cardNumber = cardNumber.text, cardNumber.count <= 16,
            let cvv = cvv.text, cvv.count <= 5,
            let expirationDate = expirationDate.text, expirationDate.count <= 4,
            let lastName = lastName.text, lastName.count > 0,
            let firstName = firstName.text, firstName.count > 0 {
            
            interactor = PaymentMethodInteractor()
            self.interactor?.delegate = self
            interactor?.verifyPaymentMethod(cardNumber: cardNumber, expirationDate: expirationDate, cvv: cvv, firstName: firstName, lastName: lastName)
            
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Card Registration Failyre", comment: ""), message: NSLocalizedString("Please verify card data and try again", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PaymentMethodEnterViewController: PaymentMethodDelegate {
    
    func paymentMethodVerificationResponce(title: String, responceStatus: String, success: Bool) {
        
        if success {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: responceStatus, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
                    MobilicardUserDefaults.shared.defaults.set(true, forKey: "User Set Payment Method")
                    let homeViewController = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(homeViewController, animated: true, completion: nil)

                }))
                self.present(alert, animated: true, completion: nil)
            }
            self.navigationController?.popViewController(animated: true)
            
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: responceStatus, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension PaymentMethodEnterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumber {
        let maxLength = 16
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
        
        if textField == cvv {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == expirationDate {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }

        return true
    }
}
