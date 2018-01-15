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
    
    var loginScreenViewController: LoginViewController?
    var window: UIWindow?
    
    func presentLoginScreenViewControllerInWindow() {
        let loginScreenViewController = UIStoryboard.init(name: Constants.loginStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.loginStoryboardIdentifier) as? LoginViewController
        self.loginScreenViewController = loginScreenViewController
        self.loginScreenViewController?.navigation = self
        self.window?.rootViewController = loginScreenViewController
        self.window?.makeKeyAndVisible()
    }
    
    func presentHomeScreen(username: String) {
        
        let chatViewController = UIStoryboard.init(name: Constants.chatStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.chatStoryboardIdentifier) as? UINavigationController
        
        self.loginScreenViewController?.present(chatViewController!, animated: true, completion: nil)
    }
    
    private struct Constants {
        static let chatStoryboardName = "Home"
        static let loginStoryboardName = "Login"
        static let chatStoryboardIdentifier = "ChatViewController"
        static let loginStoryboardIdentifier = "LoginViewController"
    }
}
