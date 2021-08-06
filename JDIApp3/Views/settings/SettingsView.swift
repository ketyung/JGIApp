//
//  SettingsView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 05/08/2021.
//

import SwiftUI

struct SettingsView : View {
    
    @Binding var viewType : FrontMenuView.ViewType
    
    @State private var alwaysSaveMapAsNewVersion : Bool = false
    
    @EnvironmentObject private var viewModel : UserViewModel
    
    @State private var promptSignOutPresented : Bool = false
  
    
    var body : some View {
        
        view()
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error!")
        })
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.signOutSuccess, content: {
            
            signOutSucessView()
        })
        .alert(isPresented: $promptSignOutPresented){
            
            Alert(title: Text("Sign Out Now?".localized),
                  primaryButton: .default(Text("OK".localized)) {
                    
                    viewModel.signOut()
                    
                },secondaryButton: .cancel())
        }
    }
}

extension SettingsView {
    
    private func view() -> some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            Common.topBar(title: "Settings".localized, switchToViewType: $viewType)
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators:false) {
                
                VStack (spacing:20){
                
                    Toggle("Always Save Map As A New Version", isOn: $alwaysSaveMapAsNewVersion)

                    Spacer().frame(height: 30)
                    
                    
                    if viewModel.hasSignedIn {
                   
                        Button(action: {
                            
                            withAnimation{
                                
                                promptSignOutPresented = true 
                            }
                        }){
                            
                            Text("Sign Out").font(.custom(Theme.fontNameBold, size: 20)).padding()
                            .foregroundColor(.white)
                            .frame(width : 160, height: 40)
                            .background(Color.blue).cornerRadius(10)
                 
                        }
                       
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width : UIScreen.main.bounds.width - 40, height: 400)
                .background(Color(UIColor(hex:"#ccddffff")!))
                .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .themeFullView()
    }
}

extension SettingsView {
    
    private func signOutSucessView() -> some View {
        
        VStack(spacing:30) {
       
            HStack {
                
                Image(systemName: "info.circle").resizable().frame(width: 30, height: 30).foregroundColor(.green)
             
                Text("You've sucessfully signed out".localized).font(.custom(Theme.fontName, size: 18)).foregroundColor(.black)
                
            }.padding()
            
            Spacer().frame(height:20)
            
        }
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 300)
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 , execute: {
                
                withAnimation{
                    
                    viewType = .menu
                    viewModel.signOutSuccess = false
                }
                
            })
        }
    }
}