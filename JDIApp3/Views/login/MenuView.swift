//
//  AfterLoginMenu.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 02/08/2021.
//

import SwiftUI

typealias MV = MenuView

struct MenuView : View {
    
    enum ViewType : Int {
        
        case templates
        
        case none
    }
    
    @State private var viewType : ViewType = .none
    
    var body : some View {
        
       switchView()
    }
}

extension MenuView {
    
    
    @ViewBuilder
    private func switchView() -> some View {
        
        switch(viewType) {
        
            case .templates :
                    
                TemplatesView(viewType: $viewType)
                .transition(.move(edge: .bottom))
               
            case .none :
                
                menu()
                .transition(.move(edge: .bottom))
               
        }
    }
    
    
    private func menu() -> some View {
        
        VStack (spacing: 20) {
            
            menuButton(text: "Templates", action: {
                
                self.viewType = .templates
            })
           
        }.padding()
    }
    
    
    private func menuButton(text : String , action : (()->Void)? = nil ) -> some View {
        
        Button(action: {

            withAnimation{
       
                action?()
            }
        }){
            
            Text(text).font(.custom(Theme.fontNameBold, size: 20))
            .padding().foregroundColor(.white).background(Color(UIColor(hex: "#335577ff")!))
            .cornerRadius(6)
            
        }

    }
}
