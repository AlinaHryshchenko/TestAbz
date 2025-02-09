//
//  User.swift
//  TestAbz
//
//  Created by Alina Hryshchenko on 07/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct User {
    var image: Image
    var name: String
    var email: String
    var phone: String
    var position: TypePosition
}

enum TypePosition: String {
    case frontend = "Frontend developer"
    case backend = "Backend developer"
    case designer = "Designer"
    case qa = "QA"
}
