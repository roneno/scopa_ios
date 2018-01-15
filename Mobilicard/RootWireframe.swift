//
//  RootWireframe.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

class RootWireframe {
    
    private let loginScreenWireframe: LoginWireframe

    init() {
        self.loginScreenWireframe = LoginWireframe.sharedInstance
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?, window: UIWindow) -> Bool {
        self.loginScreenWireframe.window = window
        self.checkIfUserLoggedOut()
        return true
    }

    func checkIfUserLoggedOut(){

        self.loginScreenWireframe.presentLoginScreenViewControllerInWindow()
    }
}

