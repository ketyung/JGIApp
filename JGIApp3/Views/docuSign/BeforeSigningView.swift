//
//  BeforeSigningView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 09/08/2021.
//

import SwiftUI

struct BeforeSigningView : View {
    
    @Binding var viewType : FMM.ViewType
    
    @State private var proceed : Bool = false
    
    var body : some View {
        
        if proceed {
            
            SigningView(viewType: $viewType)
        }
        else {
            
            view()
        }
        
    }
}

extension BeforeSigningView {
    
    private func view() -> some View {
        
        VStack {
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Choose your options", switchToViewType: $viewType)
        
            ScrollView(.vertical, showsIndicators: false){
           
                TemplatesView()
                
                RecipientsView()
                
                Button(action : {
                    
                    withAnimation{
                        
                        proceed = true
                    }
                }){
                    
                    Text("Proceed").font(.custom(Theme.fontNameBold, size: 20))
                    .padding(10)
                    .frame(width: 160)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
               
                Spacer()
              
            }
            
            Spacer()
            
        }
        .padding()
    }
}
