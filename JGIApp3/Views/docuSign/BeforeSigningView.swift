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
        
            ScrollView([], showsIndicators: false){
           
                TemplatesView().frame(maxHeight:150)
                
                RecipientsView()
                
                Spacer()
                
                Button(action : {
                    
                }){
                    
                    Text("Proceed").font(.custom(Theme.fontNameBold, size: 20))
                    .padding()
                    .foregroundColor(.white).background(Color.blue)
                    .cornerRadius(20)
                }
               
            }
            
            Spacer()
            
        }
        .padding()
    }
}
