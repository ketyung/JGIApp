//
//  ContentForSigning.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import Foundation

typealias Recipient = ContentForSigning.Recipient


struct ContentForSigning {
    
    
    struct Recipient : Equatable {
        
        var id : String?
        
        var name : String?
        
        var email : String?
        
        var groupName : String?
        
        static func == (lhs: Recipient, rhs: Recipient) -> Bool {
            return lhs.id  == rhs.id
        }
        
    }
    
    
    var templateId : String?
    
    var mapId : String?
    
    var versionNo : Int?
    
    var title : String?
    
    var note : String?
    
    var attachment : Data?
    
    var recipients : [Recipient]?
    
    var signingCompleted : Bool = false 
    
}
