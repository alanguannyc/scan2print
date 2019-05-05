//
//  QrCode.swift
//  QRCodeScanner
//
//  Created by Alan Guan on 5/4/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import Foundation
import RealmSwift
class QRCode: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var content = ""
    @objc dynamic var number : Int = 0
    @objc dynamic var date = Date()
}
