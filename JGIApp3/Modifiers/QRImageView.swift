//
//  QRImageView.swift
//  TzWallet
//
//  Created by Chee Ket Yung on 26/07/2021.
//

import SwiftUI


struct QRImageView : UIViewRepresentable {
    
    var uiImage : UIImage
    
    
    func makeUIView(context: Context) -> UIImageView {

        let imgView = UIImageView(image: uiImage)
        
        imgView.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        return imgView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }

}
