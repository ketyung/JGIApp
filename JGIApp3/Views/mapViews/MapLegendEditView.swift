//
//  MapLegendEditView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import SwiftUI

struct MapLegendEditView : View {
    
    @Binding var isPresented : Bool
    
    @State private var selectedColor : String = ""
    
    @StateObject private var viewModel = MapLegendItemsViewModel()
    
    var body: some View {
        
        VStack {
            
            Spacer().frame(height: 30)

            topBar()
            
            itemScrollView()
            
            Spacer()
        }
    }
}

extension MapLegendEditView {
    
    private func topBar() -> some View {
        
        HStack {
            
            Spacer().frame(width: 5)
            
            Button(action : {
                
                withAnimation{
                    
                    isPresented = false
                }
                
            }){
           
                Common.buttonView("close", imageColorInvert: true)
               
            }
                
            Text("Define Map Legend".localized).font(.custom(Theme.fontNameBold, size: 22)).foregroundColor(.black)
           
            Spacer()
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.addItem(MapLegendItem(id: viewModel.items.count + 1))
                }
            }){
           
                Common.buttonView(imageSysteName: "plus")
               
            }
            
            Spacer().frame(width: 5)
        }
    }
}


extension MapLegendEditView {
    
    @ViewBuilder
    private func colorsScrollView() -> some View {
        
        
        ScrollView(.horizontal, showsIndicators: false ) {
            
            HStack {
                
                ForEach( FrontMapView.colorHexes, id:\.self) {
                    
                    color in
                    
                    ZStack {
                    
                        
                        if selectedColor == color {
                            
                            Circle().fill(Color(UIColor(hex:"#009900ff")!))
                            .frame(width: 30, height: 30)
                        }
                        
                        
                        Circle().fill(Color(UIColor(hex:color)!)).frame(width: 24, height: 24)
                        
                        
                    }
                    .onTapGesture {
                    
                    }
                   
                   
                }
                
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 100 ,height: 40)
        }
        .padding()
        .background(Color(UIColor(hex:"#ddddddff")!))
        .frame(width: UIScreen.main.bounds.width - 40 ,height: 40)
        .cornerRadius(10)
        .border(Color.black, width: 1, cornerRadius: 10)
       
    }
}


extension MapLegendEditView {
    
    
    private func itemScrollView () -> some View {
        
        
        ScrollView (.vertical, showsIndicators:false)
        {
            
            VStack{
                
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                    
                    let b = Binding(
                        get: { return viewModel.items[safe:index]?.text ?? "Label \((index + 1))" },
                        set: { (newValue) in return viewModel.items[index].text = newValue }
                    )
                   
                    HStack {
                        
                        Rectangle().fill(Color(UIColor(hex:item.color ?? "#ff9933ff")!)).frame(width: 30, height: 30)
                        
                        Common.textFieldWithUnderLine("Label ...", text: b)
                        .frame(minWidth: 200)
                        
                        
                        Spacer()
                        
                        Button(action : {
                            

                            viewModel.items.remove(at: index)

                        }){
                            
                            Image(systemName: "trash").resizable().frame(width:24)
                            .foregroundColor(.black)
                        }
                        
                        
                        
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 10)
                    .background(Color(UIColor(hex:"#ccddeeff")!))
                    .cornerRadius(10)
                    
                }
            }
        }
    }
}
