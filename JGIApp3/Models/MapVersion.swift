//
//  MapVersion.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import Foundation

struct MapVersion : Codable {
    
    var id : String?
    
    var versionNo : Int?
    
    var status : UserMap.Status?
    
    var createdBy : String?
    
    var createdByName : String?
    
    var latitute : Double?
    
    var longitute : Double?
    
    var levelOfDetail : Int?
    
    var items : [MapVersionItem]?
    
    var notes : [MapVersionNote]?
    
    var legendItems : [MapLegendItem]?
    
    var legendTitle : String?
    
    var lastUpdated : Date?
    
    mutating func addNote(_ note : MapVersionNote) {
        
        if notes == nil {
            
            notes = []
        }
        notes?.append(note)
    }
    
}
