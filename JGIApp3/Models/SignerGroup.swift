//
//  SignerGroup.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import Foundation

struct Signer : Codable {
    
    enum SignStatus : String, Codable {
        
        case signed = "Y"
        
        case not = "N"
    }
    
    var id : String?
    
    var signed : SignStatus?
    
    var dateSigned : Date?
    
    var lastUpdated : Date?
}

struct SignerGroup : Codable {
    
    var mapId : String?
    
    var versionNo : Int?
    
    var signers : [Signer]?
    
}
