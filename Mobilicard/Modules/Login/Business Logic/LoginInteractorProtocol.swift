//
//  LoginInteractorProtocol.swift
//  Mobilicard
//
//  Created by Vsevolod on 1/15/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

protocol LoginInteractorProtocol: class {
    func sendRequestForSMS(phoneNumber: String) -> String?
    func verifyOTP(otp: Int) -> String?
}
