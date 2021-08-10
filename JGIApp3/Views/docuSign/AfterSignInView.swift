//
//  AfterSignInView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import SwiftUI

struct AfterSignInView : View {
    
    @State var viewModel : AuthenticationViewModel
   
    @State private var switchToSigning : Bool = false
    
    @Binding var viewType : FMM.ViewType
   
    
    var body : some View {
        
        VStack {
            
            if !viewModel.errorPresented {
                view()
            }
            else {
                
                errorView()
            }
            
        }
        .themeFullView()
    }
}

extension AfterSignInView {
    
    
    @ViewBuilder
    private func view() -> some View {
        
        if switchToSigning {
            
            BeforeSigningView(viewType: $viewType)
            .transition(.move(edge: .bottom))
            
        }
        else {
            
            signInSuccessView()
            .onAppear{
            
                withAnimation(Animation.easeIn(duration: 0.5).delay(0.5) ){
               
                    self.switchToSigning = true
                }
            
            }
        }
    }
    
    private func errorView() -> some View {
        
        VStack {
  
            Spacer().frame(height:50)
            Common.topBar(title: "Error", switchToViewType: $viewType )
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "")
            
            Spacer()
      
        }
       
    }
    
    
    private func signInSuccessView() -> some View {
       
        VStack {
       
            Spacer().frame(height: 100)
           
            
            VStack(spacing: 20) {
                
                Image(systemName: "checkmark.circle.fill").resizable()
                .frame(width:80, height:80).foregroundColor(.green)
                
                Text("Sign In Success").font(.custom(Theme.fontName, size: 20)).foregroundColor(.black)
       
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 40, height: 300)
            .border(.green, width: 1, cornerRadius: 6)
            
            Spacer()
            
        }
       
    }
}
