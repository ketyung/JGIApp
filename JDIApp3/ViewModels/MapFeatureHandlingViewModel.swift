//
//  MapFeatureHandlingViewModel.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 31/07/2021.
//

import Foundation
import ArcGIS
import SwiftUI

typealias MFHVM = MapFeatureHandlingViewModel


protocol MapActionHandler {
    
    var featureTable : AGSServiceFeatureTable? { get set }
    
    var mapView : AGSMapView? { get set }
    
    var mapActionDelegate : MapActionDelegate? { get set }
    
    var mapPoints : [AGSPoint] { get set }
    
    var screenPoint : CGPoint? { get set }
    
    var selectedColor : UIColor { get set }
    
    func actionFor(_ type : MFHVM.ActionType, featureTable : AGSServiceFeatureTable?)
   
    func actionFor(_ type : MFHVM.ActionType, screenPoint : CGPoint)
    
   
    func addFeature()
    
}

class MapFeatureHandlingViewModel : ViewModel  {
    
    enum ActionType : Int {
        
        case presentOptions
        
        case addFeatures
        
        case editFeatures
        
        case addPoint
        
        case addLine
        
        case addPolygon
        
        case none
    }
    
    var featureTable : AGSServiceFeatureTable?
    
    var mapPoints : [AGSPoint] = []
    
    var mapView: AGSMapView?
    
    weak var mapActionDelegate: MapActionDelegate?
    
    @Published var screenPoint: CGPoint?
    
    @Published var optionsPresented : Bool = false
    
    @Published var selectedColor: UIColor = .red
    
    private var actionType : ActionType = .none
    
}

extension MapFeatureHandlingViewModel {
    
    
    private func applyEdits() {
        
        
        if let featureTable = featureTable {
    
            featureTable.applyEdits { [weak self] featureEditResults, error in
                guard let error = error else {
                
                    
                    if let featureEditResults = featureEditResults {
                 
                        if featureEditResults.first?.completedWithErrors == false {
                        
                            print("added.feature::\(featureEditResults)")
                        }
                        else {
                            
                            self?.errorMessage = "Some Error Could Happen!"
                            self?.errorPresented = true
                        }
                        
                        
                    }
                    
                    return
                }
              
                self?.errorMessage = error.localizedDescription
                self?.errorPresented = true
                self?.inProgress = false
                
            }
            
        }
            
    }
      
}

extension MapFeatureHandlingViewModel : MapActionHandler {
    
    func addFeature() {
        
        withAnimation{
            
            self.optionsPresented = false 
        }
        
        guard let mapPoint = mapPoints.first, let mapView = mapView, let featureTable = featureTable,
              let normalizedGeometry = AGSGeometryEngine.normalizeCentralMeridian(of: mapPoint)
        else {
            
            return
        }
        
        print("mapPoint::\(mapPoint.x):\(mapPoint.y)::canAdd::\(featureTable.canAddFeature)")

        print("featureTable.::\(String(describing: featureTable.credential))::\(featureTable.apiKey)")
        
        self.inProgress = true
    
        mapView.isUserInteractionEnabled = false
       
            
            // attributes for the new feature
        let featureAttributes = ["typdamage": "Minor", "primcause": "Earthquake"]
        
        let feature = featureTable.createFeature(attributes: featureAttributes, geometry: normalizedGeometry)
        

      
        featureTable.add(feature) { [weak self]  error in
            
            if let error = error {
              
                
                print("error.is::\(error)")
                self?.errorMessage = error.localizedDescription
                
                self?.errorPresented = true
            }
            else {
                self?.applyEdits()
            }
            // enable interaction with map view
            mapView.isUserInteractionEnabled = true
            self?.inProgress = false 
        }
        
            
        
    }
    
    
}

extension MapFeatureHandlingViewModel {
    
    func actionFor(_ type : MFHVM.ActionType, screenPoint : CGPoint){
        
        withAnimation{
   
            self.actionType = type
            self.screenPoint = screenPoint
        }
        
    }
    
    
    func actionFor(_ type: ActionType, featureTable : AGSServiceFeatureTable? = nil ) {
        
        withAnimation{
   
            self.actionType = type
            self.featureTable = featureTable
       
            switch(self.actionType){
            
                case .presentOptions :
                
                    self.optionsPresented = true
                    
                case .addFeatures :
                    
                    self.addFeature()
                    
                case .addPoint :
                    
                    self.addPoint()
            
                default :
                    return 
                
            }
        }
    }
}


extension MapFeatureHandlingViewModel {
    
    private func addPoint(){
        
        withAnimation{
            
            self.optionsPresented = false
        }
        
        if let point = mapPoints.first {
     
            mapActionDelegate?.addPoint(point, color: selectedColor)
         
        }
       
        
        mapPoints.removeAll()
        
        mapActionDelegate = nil 
        
    }
}
