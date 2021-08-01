//
//  TemplatesView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import SwiftUI


struct TemplatesView : View {
    
    @Binding var viewType : MenuView.ViewType
    
    @StateObject private var viewModel = TemplatesViewModel()
    
    var body: some View {
        
        VStack {
            
            Spacer().frame(height:50)
            
            Common.topBar(title: "Templates", switchToViewType: $viewType)
            
            List(viewModel.templates, id:\.templateId) {
                templ in
                
                Text("\(templ.name)").font(.custom(Theme.fontName, size: 18))
            }

        }
       // .themeFullView()
        .progressView(isShowing: $viewModel.inProgress)
        .popOver(isPresented: $viewModel.errorPresented, content: {
            
            Common.errorAlertView(message: viewModel.errorMessage ?? "")
        })
        .onAppear{
            
            viewModel.fetchTemplates()
        }
    }
}
