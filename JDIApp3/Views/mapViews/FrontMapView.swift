//
//  ContentView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI

struct FrontMapView: View {
    
    @EnvironmentObject private var viewModel : MFHVM
    
    
    private let colors : [UIColor] = [.white, .gray, .black, .red, .orange,
                .yellow, .green, .blue, .cyan,  .purple]
   
    
    @State private var showTopToolbar : Bool = true
    
    
    var body: some View {
      
        VStack{
            
            ArcGISMapView(mapActionHandler: viewModel)
            
        }
        .themeFullView()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "Error")
        })
        .popOverAt(.topRight, isPresented: $showTopToolbar, content: {
            
            topMenuBar()
        })
        .bottomSheet(isPresented: $viewModel.optionsPresented, height: 200, showGrayOverlay: true, content:{
            
            optionsSheetView()
        })
        .bottomSheet(isPresented: $viewModel.saveSheetPresented, height: UIScreen.main.bounds.height - 100, showGrayOverlay: true, content:{
            
            MapInfoEntryView()
        })
    }
}


extension FrontMapView {
    
    private func topMenuBar() -> some View {
        
        HStack(spacing: 20) {
            
            Spacer()
            
            Button(action : {}){
                
                Common.buttonView(imageSysteName: "gear")
           
            }
           
            Button(action : {
                
                withAnimation{
                    
                    viewModel.saveSheetPresented = true 
                }
                
            }){
           
                Common.buttonView(imageSysteName: "checkmark")
            }
            .opacity(viewModel.edited ? 1 : 0.35)
            .disabled(!viewModel.edited)
           
        }
        .padding()
        .frame(width: 200, height: 40)
    }
}


extension FrontMapView {
    
    private func optionsSheetView() -> some View {
        
        ScrollView([], showsIndicators: false){
            
            addPointButton()
            
            addFeatureButton()
           
        }
    }
    
    
    private func addPointButton() -> some View {
        
        Button(action : {
            
            viewModel.actionFor(.addPoint)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Point".localized).font(.custom(Theme.fontName, size: 16))
          
                colorsScrollView()
                
                Spacer()
              
            }.padding()
        }
       
    }
    
    
    private func addFeatureButton() -> some View {
        
        Button(action : {
            
            viewModel.actionFor(.addFeatures)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Feature".localized).font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
              
            }.padding()
        }
       
    }
    
    
    

}




extension FrontMapView {
    
    @ViewBuilder
    private func colorsScrollView(actionType : MFHVM.ActionType = .addPoint) -> some View {
        
        
        ScrollView(.horizontal, showsIndicators: false ) {
            
            HStack {
                
                ForEach(colors, id:\.self) {
                    
                    color in
                    
                   
                   
                    ZStack {
                    
                        
                        if viewModel.selectedColor == color {
                            
                            Circle().fill(Color(UIColor(hex:"#009900ff")!))
                            .frame(width: 30, height: 30)
                           
                            
                        }
                        
                        
                        Circle().fill(Color(color)).frame(width: 24, height: 24)
                        
                        
                    }
                    .onTapGesture {
                    
                        withAnimation{
                  
                            viewModel.selectedColor = color
                            
                            viewModel.actionFor(actionType)
                       
                      
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
