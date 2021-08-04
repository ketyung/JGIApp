//
//  MapVersionNote.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import Foundation

struct MapVersionNote : Codable {
    
    var id : String?
    
    var mapId : String?
    
    var versionNo : Int?
    
    var uid : String?
    
    var title : String?
    
    var note : String?
    
    var lastUpdated : Date?
}
