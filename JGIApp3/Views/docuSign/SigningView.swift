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
    
    @EnvironmentObject private var signingViewModel : CFSVM
   
    var body: some View {
        
        VStack{
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Signing", switchToViewType: $viewType)
            
            if signingViewModel.siginingCompleted {
                
                completedView()
          
            }
            else {
                
                DocuSignSigningView ()
                
              
            }
            
            Spacer()
            
        }
        .padding()
        .themeFullView()
    }
}

extension SigningView {
    
    
    private func completedView() -> some View {
        
        HStack {
            
            Image(systemName: "info.circle.fill").resizable().foregroundColor(.green).frame(width:30, height: 30)
            
            Text("Completed".localized).font(.custom(Theme.fontName, size: 30))
            
            Spacer()
        }
    }
}
