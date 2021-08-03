//
//  ContentView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI

struct FrontMapView: View {
    
    @EnvironmentObject private var viewModel : MFHVM
    
    
    private static let colorHexes : [String] = ["#ffffffff", "#888888ff", "#000000ff", "#ff0000ff", "#ffaa22ff",
                "#ffff00ff", "#00ff00ff", "#0000ffff", "#0088ffff",  "#ff00ffff"]
   
    
    private  var colors : [UIColor] = {
        
        FrontMapView.colorHexes.map {
            UIColor(hex:$0)!
        }
    }()
    
   
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
        .bottomSheet(isPresented: $viewModel.optionsPresented, height: 400, showGrayOverlay: true,
                     topBarBackgroundColor: Color(UIColor(hex:"#ddeeffff")!) ,
                     content:{
            
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
            
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.mapActionDelegate?.removeLast()
                }
                
            }){
                
                Common.buttonView("undo", imageColorInvert: true)
           
            }
            .opacity(viewModel.edited ? 1 : 0)
            .disabled(!viewModel.edited)
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.optionsPresented = true 
                }
                
            }){
                
                Common.buttonView(imageSysteName: "gear")
           
            }
           
            Button(action : {
                
                withAnimation{
                    
                    viewModel.saveSheetPresented = true 
                }
                
            }){
           
                Common.buttonView(imageSysteName: "checkmark.circle")
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
        
        ScrollView(.vertical, showsIndicators: false){
            
            VStack {
        
                
                colorsScrollView()
              
                addPointButton()
                
                addLineButton()
                
                addPolygonButton()
                
                addFeatureButton()
            
            }
            
           
        }
        .background(Color(UIColor(hex:"#ddeeffff")!))
    }
    
    
    private func addPointButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addPoint)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Point".localized).font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addPoint) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addLineButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addLine)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Rectangle().fill(Color.black).frame(width: 30, height: 30)
                    
                    Image("line").resizable().frame(width: 24, height: 24).colorInvert()
                    
                }
                
                
                Text("\("Add Line".localized) ").font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
              
                if viewModel.isAction(type: .addLine) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
                
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addPolygonButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addPolygon)
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Rectangle().fill(Color.black).frame(width: 30, height: 30)
                    
                    Image("polygon").resizable().frame(width: 24, height: 24).colorInvert()
                    
                }
                
                
                Text("Add Polygon".localized).font(.custom(Theme.fontName, size: 15))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addPolygon) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
                
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        }
       
    }
    
    
    private func addFeatureButton() -> some View {
        
        Button(action : {
            
            viewModel.set(actionType: .addFeature)
           
            
        }) {
       
            HStack(spacing:20) {
                
                
                ZStack {
                    
                    Circle().fill(Color.black).frame(width: 30, height: 30)
                    Circle().fill(Color(viewModel.selectedColor)).frame(width: 24, height: 24)
                   
                }
                
                
                Text("Add Feature".localized).font(.custom(Theme.fontName, size: 16))
          
                
                Spacer()
                
                if viewModel.isAction(type: .addFeature) {
              
                    Image(systemName: "checkmark.circle").resizable().frame(width: 24, height: 24).foregroundColor(.green)
                  
                    Spacer().frame(width: 10)
                }
              
            }.padding()
            .background(Color(UIColor(hex:"#eeeeffff")!))
        
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
                            
                            viewModel.actionForSelectedType()
                       
                      
                        }
                    }
                   
                   
                }
                
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor(hex:"#ddddddff")!))
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 40)
        .cornerRadius(10)
        .border(Color.black, width: 1, cornerRadius: 10)
       
    }
}
