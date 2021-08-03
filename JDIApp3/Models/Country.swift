//
//  Country.swift
//  KyPayApp2
//
//  Created by Chee Ket Yung on 14/06/2021.
//

import Foundation
import UIKit

struct Country : Decodable {
    

    static let defaultCountry = "MY"
    
    var name : String?
    
    var code : String?

    var dialCode : String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case code
        case dialCode
    }
    
    var flag : UIImage? {
        
        return UIImage(named: "CountryPickerView.bundle/Images/\(code?.uppercased() ?? Country.defaultCountry)")
            
    }
    
    static let countries = Bundle.main.decodeJson([Country].self, fileName: "CountryPickerView.bundle/Data/CountryCodes.json")

}

extension Country{
    
    static func phoneNumberOnly (_ phoneNumber : String, countryCode : String) -> String{
        
        let dialCode = dialCode(countryCode: countryCode)
        
        return phoneNumber.deletingPrefix(dialCode)
    }
    
    
    static func dialCode(countryCode : String) -> String {
        
        let fcountries = Country.countries.filter({ $0.code?.contains(countryCode) ?? false  } )
        
        let dialCode = fcountries.first?.dialCode ?? "+60"
        
        return dialCode
      
    }

}
