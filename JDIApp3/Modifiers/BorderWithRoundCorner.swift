//
//  BorderWithRoundCorner.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation
import SwiftUI

struct BorderWithRoundCorner : ViewModifier {
    
    
    let color : Color
    
    let width : CGFloat
    
    let cornerRadius : CGFloat
    
    public func body(content: Content) -> some View {
 
        content
        .overlay(
        
            RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(color, lineWidth: width)
            
        )
    }
    
}

extension View {
    
    
    func border(_ color : Color, width : CGFloat, cornerRadius : CGFloat  ) -> some View {
        
        return self.modifier(BorderWithRoundCorner(color: color, width: width, cornerRadius:cornerRadius))
    }
}
