//
//  DateFormatterExt.swift
//  KyPayApiTester
//
//  Created by Chee Ket Yung on 09/06/2021.
//

import Foundation

extension DateFormatter {
    
    
    func jsonDateEncodingStrategy(dateFormat : String ) -> JSONEncoder.DateEncodingStrategy{
    
        self.dateFormat = dateFormat
        return .formatted(self)
    }
    
    
    func jsonDateDecodingStrategy(dateFormat : String ) -> JSONDecoder.DateDecodingStrategy{
    
        self.dateFormat = dateFormat
        self.locale = Locale(identifier: "en_US_POSIX")
        return .formatted(self)
    }
    
    static func string( from : Date ,dateFormat : String = "yyyy-MM-dd HH:mm:ss"  ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormat
        
        
        return dateFormatter.string(from: from)
    }
    
    
    static func date(from string : String, format : String = "yyyy-MM-dd HH:mm:ss" ) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:string)
    }
    
    static var decodingStrategy : JSONDecoder.DateDecodingStrategy {
        
        return DateFormatter().jsonDateDecodingStrategy(dateFormat: "yyyy-MM-dd HH:mm:ss" )
    
    }
    
    static var encodingStrategy : JSONEncoder.DateEncodingStrategy {
        
        return DateFormatter().jsonDateEncodingStrategy(dateFormat: "yyyy-MM-dd HH:mm:ss" )
    
    }
   
}
