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
    
    init(){
        
        setupOAuth()
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
    
    
    
    func loadFolders(completion : ((Error?)-> Void)? = nil ){
        
        portal.load { [weak self] error in
            
            guard let error = error else {
                
                
                self?.portal.user?.fetchContent { _, folders, _ in
                    
                    if let portalFolders = folders {
                        self?.portalFolders = portalFolders
                    }
                }
                
                completion?(nil)
                
                return
            }
            
            completion?(error)
        
        }
    }
    
    
    
    func save(mapView : AGSMapView, title : String, tags : [String],
              description : String, folder :  AGSPortalFolder?, completion : ((Error?)-> Void)? = nil){
        
     
        mapView.map?.initialViewpoint = mapView.currentViewpoint(with: AGSViewpointType.centerAndScale)
               
               mapView.exportImage { [weak self] (image: UIImage?, error: Error?) in
                   
                   // Crop the image from the center.
                   // Also to cut on the size.
                  let croppedImage: UIImage? = image?.croppedImage(CGSize(width: 200, height: 200))
                   
                  if let portal = self?.portal {
                  
                        mapView.map?.save(as: title, portal: portal, tags: tags, folder: folder,
                        itemDescription: description, thumbnail: croppedImage,
                        forceSaveToSupportedVersion: true) {
                             error in
                             
                             completion?(nil)
                        }
                    
                  }
                  
        }
        
    }
    
    
}


private extension UIImage {

    func croppedImage(_ size: CGSize) -> UIImage {
        // Calculate rect based on input size.
        let originX = (size.width - size.width) / 2
        let originY = (size.height - size.height) / 2
        
        let scale = UIScreen.main.scale
        let rect = CGRect(x: originX * scale, y: originY * scale, width: size.width * scale, height: size.height * scale)
        
        // Crop image.
        let croppedCGImage = cgImage!.cropping(to: rect)!
        let croppedImage = UIImage(cgImage: croppedCGImage, scale: scale, orientation: .up)
        
        return croppedImage
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



