//
//  MapVersion.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import Foundation

struct MapVersion : Codable {
    
    var id : String?
    
    var versionNo : String?
    
    var status : UserMap.Status?
    
    var createdBy : String?
    
    var latitute : Double?
    
    var longitute : Double?
    
    var levelOfDetail : Int?
    
    var lastUpdated : Date?
}
