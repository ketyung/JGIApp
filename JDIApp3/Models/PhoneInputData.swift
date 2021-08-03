//
//  PhoneInput.swift
//  KyPayApp2
//
//  Created by Chee Ket Yung on 14/06/2021.
//

import Foundation


struct PhoneInputData {
    
    var selectedCountry : Country?
    
    var enteredPhoneNumber : String = ""
    
    var phoneNumberIsFirstResponder : Bool = false
    
    var isCountryPickerPresented : Bool = false
    
    var isOTPViewPresented : Bool = false

    var failedSigningIn : Bool = false
    
    var signInError : Error? 
}

