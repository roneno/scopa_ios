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
    private let homeScreenWireframe: HomeWireframe

    init() {
        self.loginScreenWireframe = LoginWireframe.sharedInstance
        self.homeScreenWireframe = HomeWireframe.sharedInstance
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?, window: UIWindow) -> Bool {
        self.loginScreenWireframe.window = window
        self.homeScreenWireframe.window = window
        self.checkIfUserLoggedOut()
        return true
    }

    func checkIfUserLoggedOut(){
        if MobilicardUserDefaults.shared.defaults.string(forKey: "User's Mobile Number") != nil {
        self.homeScreenWireframe.presentHomeScreenViewControllerInWindow()
        } else {
            self.loginScreenWireframe.presentLoginScreenViewControllerInWindow()
        }
    }
}

