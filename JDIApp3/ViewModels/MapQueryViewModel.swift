//
//  MapFeaturesLayerViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 29/07/2021.
//

import Foundation

typealias MQVM = MapQueryViewModel

class MapQueryViewModel : ViewModel {
    
    @Published var maps :  [UserMap] = []
    
}

extension MapQueryViewModel  {

    
    func fetchMaps( userId : String) {
        
        self.inProgress = true
        
        ARH.shared.fetchMaps(uid: userId, completion: {
            
            [weak self] res in
            
            DispatchQueue.main.async {
                
                switch(res) {
                
                    case .failure(let err) :
                        self?.errorMessage = (err as? ApiError)?.errorText
                        self?.errorPresented = true
                        self?.inProgress = false
                        
                    case .success(let maps) :
                    
                       // print("maps::\(maps)")
                        self?.inProgress = false
                        self?.maps = maps
                    
                    
                }
                
            }
            
        })
    }
    
    
}
