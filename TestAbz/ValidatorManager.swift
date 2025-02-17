

import Foundation

struct ValidatorManager {
    var name: String
    var email: String
    var phone: String
    
    
    static func isValidName(_ name: String) -> Bool {
        return name.count >= 2 && name.count <= 10
    }
    
//    static func isValidEmail(_ email: String) -> Bool {
////        let emailRegex = #"^(?:[A-Z0-9a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Z0-9a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[A-Z0-9a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[A-Z0-9a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$"#
////        
//        let emailRegex =  #"^(?:[A-Z0-9a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Z0-9a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[A-Z0-9a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[A-Z0-9a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$"#
//            
//        return email.count >= 6 &&
//               email.count <= 100 &&
//               NSPredicate(format: "SELF MATCHES[c] %@", emailRegex).evaluate(with: email)
//    }
    
    static func isValidEmail(_ email: String) -> Bool {
           let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
           guard let regex = try? NSRegularExpression(pattern: emailRegex, options: .caseInsensitive) else {
               return false
           }
           let range = NSRange(location: 0, length: email.utf16.count)
           return regex.firstMatch(in: email, options: [], range: range) != nil
       }
  
    
    
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = #"^[\+]?380([0-9]{9})$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    static func isValid(name: String, email: String, phone: String) -> Bool {
           return ValidatorManager.isValidName(name) &&
                  ValidatorManager.isValidEmail(email) &&
                  ValidatorManager.isValidPhone(phone)
       }
}
