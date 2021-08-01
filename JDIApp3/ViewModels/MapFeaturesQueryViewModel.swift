//
//  MapFeaturesLayerViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 29/07/2021.
//

import Foundation
import ArcGIS

protocol MapFeaturesParam {
    
    func set(originFeature: AGSArcGISFeature , originFeatureTable: AGSServiceFeatureTable)
}

class MapFeaturesQueryViewModel : ObservableObject {
    
    @Published var features :  [AGSFeature] = []
    
    @Published var inProgress : Bool = false
    
    @Published var errorPresented : Bool = false
    
    @Published var errorMessage : String?

    private var originFeature: AGSArcGISFeature?
    
    private var originFeatureTable: AGSServiceFeatureTable?
    
    private lazy var agh = AGH()
    
}

extension MapFeaturesQueryViewModel : MapFeaturesParam {
    
    func set(originFeature: AGSArcGISFeature, originFeatureTable: AGSServiceFeatureTable) {
        self.originFeature = originFeature
        self.originFeatureTable = originFeatureTable
    }
    
    func queryRelatedFeatures(){
        
        inProgress = true
        
        if let originFeature = originFeature, let originFeatureTable = originFeatureTable{
  
            agh.queryRelatedFeatures(originFeature: originFeature, originFeatureTable: originFeatureTable,
             completion: { [weak self]  result , err in
                
                    guard let err = err else {
                    
                        if let res = result {
                            
                            self?.features = res
                            
                            DispatchQueue.main.async {
                                
                                self?.inProgress = false
                            }
                            return
                        }
                      
                        return
                        
                    }
                
                    if let error = err as? AGH.ArgGISError {
                    
                        DispatchQueue.main.async {
                            
                            self?.errorMessage = error.localizedDescription
                            self?.errorPresented = true
                        }
                        
                    }
                    
             })
      
        }
    }
}
