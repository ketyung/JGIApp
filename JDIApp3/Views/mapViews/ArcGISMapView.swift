//
//  FrontMapView.swift
//  JDIApp
//
//  Created by Chee Ket Yung on 28/07/2021.
//

import SwiftUI
import ArcGIS



struct ArcGISMapView : UIViewRepresentable {
    
    var mapActionHandler : MapActionHandler? = nil
    
    private let mapView = AGSMapView()
    
    private let urlString = "https://services3.arcgis.com/WtFZIDPTjFVIWtIw/arcgis/rest/services/redlist_species_data_7b024e640fd848a2adf08e43737b5cb3/FeatureServer/0"
    
    private var featureTable : AGSServiceFeatureTable {
        
        let url = URL(string: urlString)!
        let table = AGSServiceFeatureTable(url: url)
       
        return table
        
    }
    
    private var featureLayer : AGSFeatureLayer  {
        
        let featureLayer = AGSFeatureLayer(featureTable: featureTable)
        
        return featureLayer
    }
    
    private var touchedMapPoints : [AGSPoint] = []
    
    
    init(mapActionHandler : MapActionHandler? = nil) {
        
        self.mapActionHandler = mapActionHandler
        self.mapActionHandler?.mapView = mapView
        
        
        mapView.setViewpoint(
           AGSViewpoint(
               latitude: 6.6111,
               longitude: 20.9394,
               scale: 72_000
           )
       )
    }
    
    
    func makeUIView(context: Context) -> AGSMapView {


        let map = AGSMap(basemapType: .topographicVector,   latitude: 6.6111,
                         longitude: 20.9394, levelOfDetail: 6)

        
        map.operationalLayers.add(featureLayer)
        
        mapView.map = map
        
        mapView.touchDelegate = context.coordinator
        
    
        return mapView
    }

    
    
    func updateUIView(_ uiView: AGSMapView, context: Context) {
    
    }
   
    
    
}

extension ArcGISMapView {
    
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator(self)
    }
    
    class Coordinator : NSObject, AGSGeoViewTouchDelegate {
            
        private var parent : ArcGISMapView
        
        init(_ parent : ArcGISMapView){
            
            self.parent = parent
        }
        
        
        
        func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
           
            
            parent.mapActionHandler?.mapPoint = mapPoint
            
            parent.mapActionHandler?.actionFor(.presentOptions, featureTable: parent.featureTable)
            
           // parent.touchedMapPoints.append(mapPoint)
            
            //addPoint(mapPoint)
            //print("point.count::\(parent.touchedMapPoints.count)")
           
        }
        
        
        private func identifyFeature(at screenPoint : CGPoint ){
            
            // identify features at tapped location
            
            parent.mapView.identifyLayer(parent.featureLayer, screenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false) { result in
                
                print("result.geoElements.count::\(result.geoElements.count)")
                
                if let feature = result.geoElements.first as? AGSFeature {
                    // select the first feature
                    //self?.selectedPark = feature
                    print("selected.feature:: \(feature)")
                    
                }
            }
        }
        
    }
    
   
}

extension ArcGISMapView.Coordinator {
    
    private func addLineAtPoints(){
        
        
    }
    
    
    private func addPoint(_ point : AGSPoint){
        
       if parent.mapView.graphicsOverlays.count == 0 {
            
            let graphicsOverlay = AGSGraphicsOverlay()
            parent.mapView.graphicsOverlays.add(graphicsOverlay)

            print("parent.mapView.graphicsOverlays.count::\(parent.mapView.graphicsOverlays.count)")
        }
       

       
        let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: .orange, size: 20.0)

        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 2.0)

        let pointGraphic = AGSGraphic(geometry: point, symbol: pointSymbol)

        //graphicsOverlay.graphics.add(pointGraphic)
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
            
            overlay.graphics.add(pointGraphic)
            print("add.symbol::\(overlay.graphics.count)")
        }

    }
}


