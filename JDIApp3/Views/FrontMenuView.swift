//
//  MenuView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 04/08/2021.
//

import SwiftUI


struct FrontMenuView : View {
    
    var body : some View {
        
        VStack(spacing:20) {
            
            Spacer().frame(height : 50)
            
            HStack(spacing:20) {
                
                mapButtonView(title: "Create Map", imageSystemName: "plus.circle")
                
                mapButtonView(title: "Review Map", imageSystemName: "list.star", borderColor: .green)
                
            }
            
            HStack(spacing:20) {
                
                mapButtonView(title: "Create Map", imageSystemName: "plus.circle")
                
                mapButtonView(title: "Review Map", imageSystemName: "list.star", borderColor: .green)
                
            }
            
            Spacer()
            
        }
    }
}


extension FrontMenuView {
    
    private func mapButtonView( title : String , imageSystemName : String,
                                borderColor : Color = .orange,
                                action : (()->Void)? = nil ) -> some View {
        
        Button(action: {
            
            action?()
        }) {
            
            VStack {
           
                Spacer().frame(height:10)
                
                ZStack {
                    
                    Image("map").resizable().frame(width: 100, height: 86).aspectRatio(contentMode: .fit)
                    
                    Image(systemName: imageSystemName).resizable().frame(width: 30, height: 30).aspectRatio(contentMode: .fit)
                    .foregroundColor(.orange)
                    .offset(x: 30, y: 30)
                    
                }
                
                Text(title).font(.custom(Theme.fontNameBold, size: 20)).foregroundColor(.white)
            }
            .padding()
            .frame(width : 160, height: 137)
            .border(borderColor, width: 1, cornerRadius: 20)
        }
        
       
    }
}


