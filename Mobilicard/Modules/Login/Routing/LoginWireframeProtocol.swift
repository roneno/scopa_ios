//
//  LoginWireframeProtocol.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import UIKit

@objc protocol LoginWireframeProtocol: class {
    func presentLoginScreenViewControllerInWindow()
    func presentHomeScreen()
}
