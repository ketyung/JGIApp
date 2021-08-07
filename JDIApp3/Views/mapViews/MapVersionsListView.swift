//
//  MapVersionsListView.swift
//  JDIApp3
//
//  Created by Chee Ket Yung on 07/08/2021.
//

import SwiftUI

struct MapVersionsListView : View {
  
    @Binding var viewType : FMM.ViewType
    
    @Binding var mapId : String
    
    
    var body : some View {
        
        VStack (alignment: .leading, spacing: 10){
            
            Spacer().frame(height: 30)
            
            Common.topBar(title: "Versions Of Map", switchToViewType: $viewType)
       
            
            
            Spacer()
        }
        .themeFullView()
    }
}
