//
//  MobilicardUserDefaults.swift
//  Mobilicard
//
//  Created by Vsevolod Ban on 2/3/18.
//  Copyright © 2018 Vsevolod. All rights reserved.
//

import Foundation

final class MobilicardUserDefaults {
    static let shared = MobilicardUserDefaults()
    fileprivate init() {  }
    let defaults = UserDefaults.standard
}

