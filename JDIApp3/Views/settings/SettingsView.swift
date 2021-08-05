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
    
    var body : some View {
        
        VStack {
            
            Spacer().frame(height:30)
            
            Common.topBar(title: "Settings".localized, switchToViewType: $viewType)
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators:false) {
                
                VStack (spacing:20){
                
                    Toggle("Always Save Map As A New Version", isOn: $alwaysSaveMapAsNewVersion)

                    Spacer().frame(height: 30)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                        
                        Text("Sign Out").font(.custom(Theme.fontNameBold, size: 20)).padding()
                        .foregroundColor(.white)
                        .frame(width : 160, height: 40)
                        .background(Color.blue).cornerRadius(10)
             
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
