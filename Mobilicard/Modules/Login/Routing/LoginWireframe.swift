//
//  LoginWireframe.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

final class LoginWireframe: LoginWireframeProtocol {    
    
    static let sharedInstance = LoginWireframe()
    fileprivate init() {}
    
    var loginScreenViewController: LoginRequestSMSViewController?
    var loginScreenVerificationViewController: LoginVerifyOTPViewController?
    var window: UIWindow?
    
    func presentLoginScreenViewControllerInWindow() {
        let loginScreenViewController = UIStoryboard.init(name: Constants.loginStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.loginStoryboardIdentifier) as? LoginRequestSMSViewController
        self.loginScreenViewController = loginScreenViewController
        self.loginScreenVerificationViewController?.navigation = self
        self.window?.rootViewController = loginScreenViewController
        self.window?.makeKeyAndVisible()
    }
    
    func presentHomeScreen() {
        
        let homeViewController = UIStoryboard.init(name: Constants.homeStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.homeStoryboardIdentifier)
        
        self.loginScreenViewController?.present(homeViewController, animated: true, completion: nil)
    }
    
    private struct Constants {
        static let homeStoryboardName = "Home"
        static let loginStoryboardName = "Login"
        static let homeStoryboardIdentifier = "HomeViewController"
        static let loginStoryboardIdentifier = "LoginViewController"
    }
}
