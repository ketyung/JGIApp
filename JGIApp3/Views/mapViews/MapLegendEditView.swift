//
//  MapLegendEditView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import SwiftUI

struct MapLegendEditView : View {
    
    @Binding var isPresented : Bool

    @State private var colorPickerPresented : Bool = false

    @State private var selectedIndex : Int = 0
    
    @StateObject private var viewModel = MapLegendItemsViewModel()
    
    @EnvironmentObject private var mapActionViewModel : MAHVM
   
    var body: some View {
        
        VStack {
            
            Spacer().frame(height: 30)

            topBar()
            
            colorsScrollView()
            
            itemScrollView()
            
            Spacer()
        }
    }
}

extension MapLegendEditView {
    
    private func topBar() -> some View {
        
        HStack(spacing:20) {
            
            Spacer().frame(width: 5)
            
            Button(action : {
                
                withAnimation{
                    
                    isPresented = false
                }
                
            }){
           
                Common.buttonView("close", imageColorInvert: true)
               
            }
                
            Text("Define Map Legend".localized).font(.custom(Theme.fontNameBold, size: 16)).foregroundColor(.black)
           
            Spacer()
            
            
            
            Button(action : {
                
                withAnimation{
                    
                    viewModel.addItem(MapLegendItem(id: viewModel.items.count + 1))
                }
            }){
           
                Common.buttonView(imageSysteName: "plus")
               
            }
            
            if viewModel.items.count > 0 {
           
                Button(action : {
                    
                    withAnimation{
                     
                        mapActionViewModel.setLegendItems( viewModel.items)
                        
                        isPresented = false 
                    }
                }){
               
                    Common.buttonView(imageSysteName: "checkmark")
                }
               
            }
            
            
            
            Spacer().frame(width: 5)
        }
    }
}


extension MapLegendEditView {
    
    @ViewBuilder
    private func colorsScrollView() -> some View {
        
        if colorPickerPresented {
       
            ScrollView(.horizontal, showsIndicators: false ) {
                
                HStack {
                    
                    ForEach( FrontMapView.colorHexes, id:\.self) {
                        
                        color in
                        
                        
                        Circle().fill(Color(UIColor(hex:color)!)).frame(width:30, height: 30)
                        .onTapGesture {
                        
                            withAnimation{
                                
                                viewModel.setColor(for: selectedIndex, color: color)
                                
                                colorPickerPresented = false
                            }
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
                        
                        
                        Rectangle()
                        .fill(Color(UIColor(hex:item.color ?? "#ff0000ff")!)).frame(width: 30, height: 30)
                        .onTapGesture {
                        
                            withAnimation{
                                
                                selectedIndex = index
                                colorPickerPresented = true
                            }
                        }
                        
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
