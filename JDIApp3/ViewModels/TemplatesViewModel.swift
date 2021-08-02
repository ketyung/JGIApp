//
//  TemplatesViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation
import DocuSignSDK

class TemplatesViewModel : ViewModel {
    
    @Published var templates : [DSMEnvelopeTemplateDefinition] = []
    
    
    private lazy var templatesManager = DSMTemplatesManager()
    
}


extension TemplatesViewModel {
    
    func fetchTemplates(){
 
       self.inProgress = true
        
       templatesManager.listTemplates() { [weak self] templates, error in
           
            guard let err = error else {
                
                if let temps = templates {
                    
                    self?.templates = temps
                    self?.inProgress = false
                    return
                }
                
                self?.errorMessage = "Nil templates"
                self?.errorPresented = true
                self?.inProgress = false
                
                return
            }
        
        
            self?.errorMessage = err.localizedDescription
            self?.errorPresented = true
            self?.inProgress = false
        
       }
    }
}
