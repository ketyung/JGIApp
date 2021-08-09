//
//  ContentForSigning.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import Foundation



struct ContentForSigning {
    
    
    struct Recipient {
        
        var name : String?
        
        var email : String?
        
        var groupName : String?
        
    }
    
    
    var mapId : String?
    
    var version : String?
    
    var title : String?
    
    var note : String?
    
    var attachment : Data?
    
    var recipients : [Recipient]?
    
}
