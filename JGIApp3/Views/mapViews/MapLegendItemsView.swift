//
//  MapLegendItemsView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import SwiftUI

struct MapLegendItemsView : View {
    
    @Binding var isPresented : Bool
    
    @EnvironmentObject private var viewModel : MLIVM
    
    @EnvironmentObject private var mapActionViewModel : MAHVM
    
    var body : some View {
        
        VStack(spacing:3) {
            
            topBar()
                
            ForEach(viewModel.items, id:\.id) {
                
                item in
                
                HStack(spacing:3) {
                    
                    Rectangle()
                    .fill(Color(UIColor(hex:item.color ?? "#ff0000ff")!)).frame(width: 30, height: 30)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                  
                    Spacer().frame(width: 3)
                    
                    Text(item.text ?? "Label").foregroundColor(.black).font(.custom(Theme.fontName, size: 16))
                    
                    
                    Spacer()
                  
                }
            }
            
            Spacer()
            
        }
        .padding()
        .background(Color.white)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                
                if let items = mapActionViewModel.mapVersion?.legendItems, items.count > 0 {
                    
                    viewModel.items = items
                }
            })
            
        }
    }
    
}


extension MapLegendItemsView {
    
    private func topBar() -> some View {
        
        HStack(spacing:20) {
            
            Spacer().frame(width: 5)
          
                
            
            Button(action: {
              
                withAnimation{
                    
                    mapActionViewModel.legendEditingViewPresented = true
                    
                }
                
            }){
          
                Text((mapActionViewModel.legendTitle?.count ?? 0) > 0 ? (mapActionViewModel.legendTitle ?? "") :
                "Define Map Legend".localized)
                .font(.custom(Theme.fontNameBold, size: 16)).foregroundColor(.black)
              
            }
           
            
            
            Button(action : {
                
                withAnimation{
                    
                    isPresented = false
                }
                
            }){
           
                Common.buttonView("close", imageColorInvert: true)
               
            }
            
            
            
        }
    }
}
