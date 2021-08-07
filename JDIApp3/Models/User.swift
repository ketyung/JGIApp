//
//  User.swift
//  KyPayApiTester
//
//  Created by Chee Ket Yung on 08/06/2021.
//

import Foundation

struct User : Codable {

    enum Stat : String, Codable{        

        case signedIn  = "SI"
        
        case signedOut = "SO"
        
        case none  = "none"
    }

    enum Status : String, Codable {
        
        case approved = "A"
        
        case new = "N"
        
        case deactivated = "D"
    }
    
    
    var id : String?
    var firstName : String?
    var lastName : String?
    var dob : Date?
    var email : String?
    var groupId : String?
    var password : String?
    var passwordAgain : String?
    var phoneNumber : String?
    var signInStat : Stat?
    var status : Status?
    var lastStatTime : Date?
    var lastUpdated : Date?

}
