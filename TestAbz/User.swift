

import Foundation
import UIKit
import SwiftUI

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photo: String
}

struct UsersResponse: Decodable {
    let success: Bool
    let users: [User]
}

enum TypePosition: String {
    case frontend = "Frontend developer"
    case backend = "Backend developer"
    case designer = "Designer"
    case qa = "QA"
}

