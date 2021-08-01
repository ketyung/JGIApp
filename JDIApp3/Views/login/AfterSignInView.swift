//
//  AfterSignInView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import SwiftUI

struct AfterSignInView : View {
    
    @State var viewModel : AuthenticationViewModel
   
    @State private var switchToMenu : Bool = false
    
    var body : some View {
        
        VStack {
            
            if !viewModel.errorPresented {
                
                view()
            }
            
        }
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "")
        })
        .themeFullView()
    }
}

extension AfterSignInView {
    
    
    @ViewBuilder
    private func view() -> some View {
        
        if switchToMenu {
            
            MenuView()
            .transition(.move(edge: .bottom))
            
        }
        else {
            
            signInSuccessView()
            .onAppear{
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    withAnimation(Animation.easeIn(duration: 0.5).delay(1) ){
                   
                        self.switchToMenu = true
                    }
                })
            }
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
