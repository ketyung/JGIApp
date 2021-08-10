//
//  MapLegendItemsViewModel.swift
//  JGIApp
//
//  Created by Chee Ket Yung on 10/08/2021.
//

import Foundation

class MapLegendItemsViewModel : ViewModel {
    
    @Published var items = [MapLegendItem]()
    
    func addItem (_ item : MapLegendItem){
        
        items.append(item)
    }
}

