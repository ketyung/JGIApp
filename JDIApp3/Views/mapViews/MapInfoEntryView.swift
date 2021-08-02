//
//  MapInfoEntryView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 02/08/2021.
//

import SwiftUI


struct MapInfoEntryView : View {
    
    @EnvironmentObject private var viewModel : MFHVM
   
    @State private var textViewFocused : Bool = false
    
    var body: some View {
        
        VStack(spacing:20){
            
            Spacer().frame(height:30)
            
            Common.textFieldWithUnderLine("Title".localized, text: $viewModel.mapTitle)
            
            VStack(alignment: .leading, spacing:5) {
           
                Common.textFieldWithUnderLine("Tags".localized, text: $viewModel.mapTags)
                
                Text("Separate tags by space".localized).font(.custom(Theme.fontName, size: 15)).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
            
            VStack(alignment: .leading, spacing:5) {
           
                Text("\("Description".localized) :").font(.custom(Theme.fontNameBold, size: 20)).foregroundColor(.gray)
          
                TextView(text: $viewModel.mapDescription, isFirstResponder: $textViewFocused)
                .frame(width: UIScreen.main.bounds.width - 10, height: 100)
               
                
            }
            
            
            Spacer()
            
        }.padding()
        .themeFullView()
    }
}
