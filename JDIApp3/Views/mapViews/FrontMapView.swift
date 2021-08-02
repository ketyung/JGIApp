//
//  ContentView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI

struct FrontMapView: View {
    
    @StateObject private var viewModel = MFHVM()
    
    var body: some View {
      
        VStack{
            
            ArcGISMapView(mapActionHandler: viewModel)
            
        }
        .themeFullView()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error")
        })
        .bottomSheet(isPresented: $viewModel.optionsPresented, height: 200, showGrayOverlay: true, content:{
            
            optionsSheetView()
        })
        
    }
}

extension FrontMapView {
    
    private func optionsSheetView() -> some View {
        
        VStack{
            
            optionButton(text: "Add feauture", imageName: "plus.circle", action: {
                
                viewModel.addFeature()
            })
            
        }
    }
    
    
    private func optionButton( text : String, imageName : String, action : (()->Void)? = nil ) -> some View{
        
        
        Button(action : {
            
            withAnimation {
      
                action?()
            }
            
        }) {
       
            HStack(spacing:20) {
                
                Image(systemName: "plus.circle").resizable().frame(width: 24, height: 24)
                
                Text(text).font(.custom(Theme.fontName, size: 16))
          
                Spacer()
              
            }.padding()
        }
       
    }
    
}
