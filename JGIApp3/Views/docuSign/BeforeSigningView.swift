//
//  BeforeSigningView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import SwiftUI

struct BeforeSigningView : View {
    
    @Binding var viewType : FMM.ViewType
    
    var body : some View {
        
        VStack {
            
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Choose your options", switchToViewType: $viewType)
            
            TemplatesView()
            
        }
    }
}
