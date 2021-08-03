//
//  Map.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import Foundation

struct UserMap : Codable {
    
    
    enum Status : String, Codable {
        
        case new = "N"
        
        case final = "F"
        
    }
    
    
    var id : String?
    
    var uid : String?
    
    var title : String?
    
    var description : String?
    
    var status : Status?
    
    var lastUpdated : Date?
    
}
