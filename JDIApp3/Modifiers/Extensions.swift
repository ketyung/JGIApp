//
//  Extensions.swift
//  JDIApp
//
//  Created by Chee Ket Yung on 28/07/2021.
//
import Foundation
import UIKit


extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {

        DispatchQueue.global(qos: .background).async {
            
            background?()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                completion?()
            })
       
        }
    }

}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
}



extension Bundle {
    
    func decodeJson <T:Decodable> (_ type : T.Type ,fileName : String,
     dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> T {
        
         guard let url = self.url(forResource: fileName, withExtension: nil) else {
             fatalError("Failed to load file ")
         }
            
         do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
                
            let result = try decoder.decode(type, from: jsonData)
            return result
         }
         catch {
            fatalError("err:\(error)")
         }
  }
}



extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    
    func hexString(_ toLowerCase : Bool = true) -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let a: CGFloat = components?[3] ?? 0.0
        

        let hexString = String.init(format: "#%02lX%02lX%02lX%02lX",
            lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)), lroundf(Float(a * 255)))
        
        let hexStr = toLowerCase ? hexString.lowercased() : hexString
        
        return hexStr
     }

}


extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    var twoDecimalString:String {
        return String(format: "%.2f", self)
    }

}



extension URL {
 
    func valueOf(_ paramName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == paramName })?.value
    }
}
