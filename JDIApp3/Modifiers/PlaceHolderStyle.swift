//
//  PlaceHolderStyle.swift
//  TzWallet
//
//  Created by Chee Ket Yung on 24/07/2021.
//

import SwiftUI


struct PlaceholderStyle: ViewModifier {
    
    var showPlaceHolder: Bool
    
    var placeholder: String

    var color : Color
    
    public func body(content: Content) -> some View {
        
        ZStack(alignment: .leading)
        {
            if showPlaceHolder {
                
                Text(placeholder)
                .padding(5)
            }
            
            content
            .foregroundColor(color)
            .padding(5.0)
        }
    }
}

extension View {
    
    func placeHolder( show : Bool, placeHolder : String , color : Color = .black) -> some View {
        
        return self.modifier(PlaceholderStyle(showPlaceHolder: show, placeholder: placeHolder, color:  color))
        
    }
}
