//
//  ArgGISHandler.swift
//  JDIApp
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import Foundation
import ArcGIS

typealias AGH = ArgGISHandler

class ArgGISHandler {
    
    private  var portalFolders = [AGSPortalFolder]()
    
    private let portal = AGSPortal.arcGISOnline(withLoginRequired: true)
  
    private var oAuthConfiguration : AGSOAuthConfiguration?
    
    
    
    struct ArgGISError : LocalizedError, CustomStringConvertible {
       
        var description: String {
            
            errorText ?? ""
        }
    
        var errorText : String?
        
        public var errorDescription : String {
            
            errorText ?? ""
        }
        
    }
    
        
    
    
    static func setup(){
        
        AGSArcGISRuntimeEnvironment.apiKey = "AAPK1ea720f891ca476cbbb582b22210f639jo403FbwOpJUJAs-cPi5iP9ktKh-FGdo2b8kiZFYc1YOMzibX9cxw2xidvI22Lm2"
    }
    
    deinit {
        // Reset the API key after successful login.
        //AGSArcGISRuntimeEnvironment.apiKey = apiKey
       
        if let oAuthConfig = self.oAuthConfiguration {
       
            AGSAuthenticationManager.shared().oAuthConfigurations.remove(oAuthConfig)
        }
        AGSAuthenticationManager.shared().credentialCache.removeAllCredentials()
    }
}

extension ArgGISHandler {
    
    
    func setupOAuth(){
    
        //let apiKey = AGSArcGISRuntimeEnvironment.apiKey
        
        oAuthConfiguration =  AGSOAuthConfiguration(portalURL: nil, clientID: "8qkRB53PZAm33zZq", redirectURL: "iOSSamples://auth")
        
        
        AGSAuthenticationManager.shared().oAuthConfigurations.add(oAuthConfiguration!)
           
              
    }
}


extension ArgGISHandler {
    
    
    func queryRelatedFeatures ( originFeature: AGSArcGISFeature , originFeatureTable: AGSServiceFeatureTable, completion : (([AGSFeature]?, Error?)-> Void)? = nil ) {
        
        
        guard let relationshipInfo = originFeatureTable.layerInfo?.relationshipInfos.first else {
            
            completion?(nil, ArgGISError(errorText: "Relationship info not found"))
            return
        }
        
        
        let parameters = AGSRelatedQueryParameters(relationshipInfo: relationshipInfo)
        
        var relatedFeatures = [AGSFeature]()
        
        // order results by OBJECTID field
        parameters.orderByFields = [AGSOrderBy(fieldName: "OBJECTID", sortOrder: .descending)]
        
        // query for species related to the selected park
        originFeatureTable.queryRelatedFeatures(for: originFeature, parameters: parameters, queryFeatureFields: .loadAll) { results, error in
            
            // dismiss progress hud
            
            guard let err = error else {
                
            
                
                if let result = results?.first {
          
                    relatedFeatures = result.featureEnumerator().allObjects
                    completion?(relatedFeatures,nil)
                    return
                }
                
                
                completion?(nil, ArgGISError(errorText: "Result not found"))
              
                return 
            }
            
            
            completion?(nil, ArgGISError(errorText: err.localizedDescription))
            
            
            
        }
        
        
    }
}



