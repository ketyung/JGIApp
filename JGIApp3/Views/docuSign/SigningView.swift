//
//  TemplateView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation
import SwiftUI


struct SigningView : View {
    
    @Binding var viewType : FMM.ViewType
    
    var body: some View {
        
        VStack{
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Signing", switchToViewType: $viewType)
            
            DocuSignSigningView ()
            
            Spacer()
            
        }
        .padding()
        .themeFullView()
    }
}
