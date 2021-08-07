//
//  CommonDimensionAndColor.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation
import SwiftUI

struct CommonDimensionAndColor : ViewModifier {
    
    public func body(content: Content) -> some View {
 
        content
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Theme.commonBgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    
    func themeFullView() -> some View {
        
        
        return self.modifier(CommonDimensionAndColor())
    }
}
