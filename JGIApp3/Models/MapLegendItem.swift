//
//  MapLegenItem.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import Foundation

struct MapLegendItem : Codable {

    var id : Int?
    
    var mapId : String?
    
    var versionNo : Int?

    var text : String?
    
    var color : String?
    
    var lastUpdated : Date?
}
