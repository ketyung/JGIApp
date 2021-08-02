//
//  ContentView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI

struct FrontMapView: View {
    
    @StateObject private var viewModel = MFHVM()
    
    private let colors : [UIColor] = [.white, .gray, .black, .red, .orange,
                .yellow, .green, .blue, .cyan,  .purple]
   
    
    
    
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
        
        ScrollView([], showsIndicators: false){
            
            addPointButton()
           
        }
    }
    
    
    private func addPointButton() -> some View {
        
        Button(action : {
            
            
        }) {
       
            HStack(spacing:20) {
                
                Circle().fill(Color.red).frame(width: 24, height: 24)
                
                Text("Add Point".localized).font(.custom(Theme.fontName, size: 16))
          
                colorsScrollView()
                
                Spacer()
              
            }.padding()
        }
       
    }
    
    

}

extension FrontMapView {
    
    @ViewBuilder
    private func colorsScrollView() -> some View {
        
        
        ScrollView(.horizontal, showsIndicators: false ) {
            
            HStack {
                
                ForEach(colors, id:\.self) {
                    
                    color in
                    
                   
                   
                    ZStack {
                    
                        
                        if let selectedColor = viewModel.selectedColor,
                           selectedColor == color {
                            
                            Circle().fill(Color(UIColor(hex:"#009900ff")!))
                            .frame(width: 30, height: 30)
                           
                            
                        }
                        
                        
                        Circle().fill(Color(color)).frame(width: 24, height: 24)
                        
                        
                    }
                    .onTapGesture {
                    
                        withAnimation{
                  
                            viewModel.selectedColor = color
                      
                        }
                    }
                   
                   
                }
                
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor(hex:"#ddddddff")!))
        .frame(width: 160,height: 40)
        .cornerRadius(10)
        .border(Color.black, width: 1, cornerRadius: 10)
       
    }
}
