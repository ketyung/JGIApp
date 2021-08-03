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
       // print("table.hasAttachements::\(table.hasAttachments)")
        
        return table
        
    }
    
    private var featureLayer : AGSFeatureLayer  {
        
        let featureLayer = AGSFeatureLayer(featureTable: featureTable)
        
        return featureLayer
    }
    
    
    
    init(mapActionHandler : MapActionHandler? = nil) {
        
        self.mapActionHandler = mapActionHandler
        
        
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

        mapView.map = map
      
        map.operationalLayers.add(featureLayer)
        
        
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
            super.init()
            self.parent.mapActionHandler?.mapActionDelegate = self
        }
        
        
        func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
            
            
            //parent.mapActionHandler?.actionFor(.presentOptions )
            
            if parent.mapActionHandler?.isAction(type: .addPoint) ?? false {
            
                parent.mapActionHandler?.mapPoints.append( mapPoint )
               
                parent.mapActionHandler?.actionForSelectedType()
                
            }
            else
            if parent.mapActionHandler?.isAction(type: .addFeature) ?? false {
            
                parent.mapActionHandler?.mapPoints.append( mapPoint )
               
                parent.mapActionHandler?.actionForSelectedType()
                
            }
            else
            if parent.mapActionHandler?.isAction(type: .addLine) ?? false {
          
                parent.mapActionHandler?.mapPoints.append( mapPoint )
                
                if (parent.mapActionHandler?.mapPoints.count ?? 0) == 1 {
                
                    self.addPoint(mapPoint, color: parent.mapActionHandler?.selectedColor, size: 2)
                }
                else
                if (parent.mapActionHandler?.mapPoints.count ?? 0) > 1 {
                    
                    self.addPoint(mapPoint, color: parent.mapActionHandler?.selectedColor, size: 2)
                    parent.mapActionHandler?.actionForSelectedType()
                }
                
            }
            
            self.setEdited()
           // identifyFeature(at: screenPoint)
        }
        
        
        
        func geoView(_ geoView: AGSGeoView, didTouchDragToScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
            
            
            if parent.mapActionHandler?.isAction(type: .addLine) ?? false {
                
                parent.mapActionHandler?.mapPoints.append(mapPoint)
                
                parent.mapActionHandler?.actionForSelectedType()
           
                print("parent.mapPoints::\(parent.mapActionHandler?.mapPoints.count ?? 0)")
                
            }
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



protocol MapActionDelegate : AnyObject {
    
    func addPoint(_ point : AGSPoint, color : UIColor?)
    
    func addLineAtPoints ( _ points : [AGSPoint] , color : UIColor?)
    
    func addFeature(at point: AGSPoint)
    
    func removeAll()
    
    func removeLast()
}

extension ArcGISMapView.Coordinator : MapActionDelegate {
    
    func addLineAtPoints ( _ points : [AGSPoint], color : UIColor? = nil ){
        
        if parent.mapView.graphicsOverlays.count == 0 {
             
             let graphicsOverlay = AGSGraphicsOverlay()
             parent.mapView.graphicsOverlays.add(graphicsOverlay)
         }
        
        let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: .orange, size: 10.0)

        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 2.0)

        //let pointGraphic = AGSGraphic(geometry: points.first, symbol: pointSymbol)

        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
            
            
            let polyline = AGSPolyline(points: points)
         
            let polylineSymbol = AGSSimpleLineSymbol(style: .solid, color: color ?? .blue, width: 2.0)

            let polylineGraphic = AGSGraphic(geometry: polyline, symbol: polylineSymbol)
            
            overlay.graphics.add(polylineGraphic)
            //overlay.graphics.add(pointGraphic)
        }

      
        
    }
   
   func addPoint(_ point : AGSPoint, color: UIColor? = nil ){
   
        addPoint(point, color:  color, size: 20)
   }
    
    private func addPoint(_ point : AGSPoint, color: UIColor? = nil, size : CGFloat? = nil ){
        
       if parent.mapView.graphicsOverlays.count == 0 {
            
            let graphicsOverlay = AGSGraphicsOverlay()
            parent.mapView.graphicsOverlays.add(graphicsOverlay)

        }
    
        let pointSymbol = AGSSimpleMarkerSymbol(style: .circle, color: color ?? .orange, size: size ?? 20)

        pointSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 1.0)

        let pointGraphic = AGSGraphic(geometry: point, symbol: pointSymbol)

        //graphicsOverlay.graphics.add(pointGraphic)
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
            
            overlay.graphics.add(pointGraphic)
        }
        
      
       
    }
    
    
    func removeLast(){
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
        
            overlay.graphics.removeLastObject()
            
            self.setEdited()
        }
        
    }
    
    
    func removeAll() {
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
        
            overlay.graphics.removeAllObjects()
            self.setEdited()
     
        }
    }
    
    
    private func setEdited(){
        
        if let overlay = parent.mapView.graphicsOverlays.firstObject as? AGSGraphicsOverlay{
      
            withAnimation{
           
                parent.mapActionHandler?.edited = overlay.graphics.count > 0
            }
        }
       
    }
}



extension ArcGISMapView.Coordinator {
    
    
    func addFeature(at point: AGSPoint) {
           // disable interaction with map view
            parent.mapView.isUserInteractionEnabled = false

           // normalize geometry
           let normalizedGeometry = AGSGeometryEngine.normalizeCentralMeridian(of: point)!

           // attributes for the new feature
           let featureAttributes = ["typdamage": "Minor", "primcause": "Earthquake"]
           // create a new feature

           let feature =  parent.featureTable.createFeature(attributes: featureAttributes, geometry: normalizedGeometry)

    
           parent.mapActionHandler?.inProgress = true
        
         
           // add the feature to the feature table
           parent.featureTable.add(feature) { [weak self] error in
              
                
               if let error = error {
              
                    print("error.addFeature::\(error)")
                
                    self?.parent.mapActionHandler?.errorMessage = error.localizedDescription
                    self?.parent.mapActionHandler?.errorPresented = true
                    self?.parent.mapActionHandler?.inProgress = false
                
               }
               else {
                   // applied edits on success
                   self?.applyEdits()
               }
               // enable interaction with map view
         
               self?.parent.mapView.isUserInteractionEnabled = true
            
           }
    }
    
    
    private func applyEdits() {
           
           parent.featureTable.applyEdits { [weak self] res , error in
            
                guard let err = error else {
                
                    if let res = res?.first, res.completedWithErrors == false {
                        
                        print("Success!:\(res.objectID)")
                        self?.parent.mapActionHandler?.inProgress = false
                    
                    }
                    
                    return
                    
                }
            
                self?.parent.mapActionHandler?.errorMessage = err.localizedDescription
                self?.parent.mapActionHandler?.errorPresented = true
                self?.parent.mapActionHandler?.inProgress = false
        
           }
       }
}



/**
extension AGSMapView {
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Touch.begin....")
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Touch.end...x")
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        print("Touch.move...x.")
    }
}
 */
