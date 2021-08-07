//
//  CommonViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//

import Foundation

class ViewModel : NSObject , ObservableObject {
    
    @Published var inProgress : Bool = false
    
    @Published var errorPresented : Bool = false
    
    @Published var errorMessage : String?
    
}
