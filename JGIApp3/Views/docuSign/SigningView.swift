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
    
    @EnvironmentObject private var signingViewModel : SVM
   
    var body: some View {
        
        VStack{
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Signing", switchToViewType: $viewType, action: {
                
                signingViewModel.reset()
            })
            
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
        
        VStack(alignment: .leading, spacing:20) {
        
           
            HStack {
                
                Image(systemName: "info.circle.fill").resizable().foregroundColor(.green).frame(width:30, height: 30)
                
                Text("Completed".localized).font(.custom(Theme.fontName, size: 30)).foregroundColor(.black)
                
                
                Spacer()
            }
    
            HStack {
                
                Text("By").font(.custom(Theme.fontName, size: 20)).foregroundColor(.black)
                
                
                Image("docusign").resizable().frame(width:80, height: 17.2).aspectRatio(contentMode: .fit)
             
            }
        }
        .padding()
        
        
    }
}
