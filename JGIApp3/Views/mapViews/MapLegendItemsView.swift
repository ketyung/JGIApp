//
//  MapLegendItemsView.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import SwiftUI

struct MapLegendItemsView : View {
    
    @EnvironmentObject private var viewModel : MapLegendItemsViewModel
    
   
    var body : some View {
        
        VStack {
            
                
            ForEach(viewModel.items, id:\.id) {
                
                item in
                
                HStack {
                    
                    Rectangle()
                    .fill(Color(UIColor(hex:item.color ?? "#ff0000ff")!)).frame(width: 30, height: 30)
                  
                    Text(item.text ?? "Label").foregroundColor(.black).font(.custom(Theme.fontName, size: 16))
                    
                    
                    Spacer()
                  
                }
                .padding()
            }
            
        }
        .padding()
        .background(Color.white)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
    
}
