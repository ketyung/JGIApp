//
//  MapVersionItem.swift
//  JDIApp3
//
//  Created by Christopher Chee on 04/08/2021.
//

import Foundation

struct MapVersionItem : Codable {
    
    enum ItemType : String, Codable {
        
        case point = "P"
        
        case line = "L"
        
        case polygon = "PL"
        
        case label = "LB"
    }
    
    var id : String?
 
    var mapId : String?
    
    var versionNo : String?
    
    var itemType : ItemType?
    
    var lastUpdated : Date?
    
}
