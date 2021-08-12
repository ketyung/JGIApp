//
//  TemplatesView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import SwiftUI


struct TemplatesView : View {
    
    
    @StateObject private var viewModel = TemplatesViewModel()
    
    @EnvironmentObject private var signingViewModel : SVM
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:20) {
            
            Text("Choose a template").font(.custom(Theme.fontName, size: 18))
            
            templatesList()
            .frame(height:120)
            
            
        }
        .padding()
        .onAppear{
            
            viewModel.fetchTemplates()
        }
        
    }
}

extension TemplatesView {
    
    
    @ViewBuilder
    private func templatesList() -> some View {
        
        
        if viewModel.templates.count > 0 {
        
            
            ScrollView(.vertical, showsIndicators: false ) {
          
                ForEach(viewModel.templates, id:\.templateId) {
                    templ in
                    
                    
                    Button (action : {
                        
                        signingViewModel.templateId = templ.templateId
                        
                    }) {
                        
                        HStack {
                       
                            Text("\(templ.name)").font(.custom(Theme.fontName, size: 16))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(1)
                            .foregroundColor(.black)
                                
                            Spacer()
                        
                            if templ.templateId == signingViewModel.templateId {
                                
                                Image(systemName: "checkmark.circle.fill").resizable().frame(width:24,height:24).foregroundColor(.green)
                                
                                Spacer().frame(width:5)
                            }
                        }
                        .padding()
                        .background(Color(UIColor(hex:"#ccddeeff")!))
                        .cornerRadius(10)
                    }
                    
                    
                    
                }
                
            }
            .padding()
          
            
        }
        else {
            
            Text("Loading templates ...").font(.custom(Theme.fontName, size: 18))
            .padding()
        }
        

    }
}
