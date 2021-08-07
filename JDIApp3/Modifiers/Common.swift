//
//  Common.swift
//  TzWallet
//
//  Created by Chee Ket Yung on 23/07/2021.
//

import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class Common {
    
    static func generateQRCode(from string: String) -> UIImage? {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle")
    }
    
    
    @ViewBuilder
    static func qrCodeImageView(from string : String, size : CGSize = CGSize(width:120, height:120)) -> some View {
        
        if let img = generateQRCode(from: string){
            
            ZStack {
       
                Rectangle().fill(Color.blue).frame(width: size.width * 1.2,height: size.width * 1.2).cornerRadius(10)
               
                QRImageView(uiImage: img).frame(width: size.width,height: size.width)
           
            }
        }
    }
    
}

extension Common {
    
    static func errorAlertView( message : String, textColor : Color = .black) -> some View {
        
         VStack {
        
             Spacer().frame(height: 30)
             
             HStack (spacing: 2) {
             
                 Image(systemName: "info.circle.fill")
                 .resizable()
                 .frame(width:24, height: 24)
                 .foregroundColor(Color(UIColor(hex:"#ee0000ff")!))
                 
                 Text(message)
                 .padding()
                 .foregroundColor(textColor)
                 .fixedSize(horizontal: false, vertical: true)
                 .font(.custom(Theme.fontName, size: 15))
                 .lineLimit(5)
             }
             .padding(4)
             
             Spacer()
         }
         .padding()
         .frame(width: UIScreen.main.bounds.width - 40 , height: 200)
         .cornerRadius(4)
         

    }
    
}

extension Common {
    
    static func textFieldWithUnderLine (_ placeHolder : String , text : Binding <String>,
                                        foregroundColor : Color = .black,
                                        underlineColor : Color = .black) -> some View {
        
        TextField(placeHolder, text: text )
        .placeHolder(show: text.wrappedValue.isEmpty,  placeHolder:  placeHolder)
        .autocapitalization(UITextAutocapitalizationType.words)
        .foregroundColor(foregroundColor)
        .overlay(VStack{Divider().background(underlineColor).offset(x: 0, y: 20)})
       
    }
    
    
    static func secureFieldWithUnderLine (_ placeHolder : String ,
    text : Binding <String>,  foregroundColor : Color = .black,
    underlineColor : Color = .black) -> some View {
        
        SecureField(placeHolder, text: text )
        .placeHolder(show: text.wrappedValue.isEmpty,  placeHolder:  placeHolder)
        .autocapitalization(UITextAutocapitalizationType.words)
        .foregroundColor(foregroundColor)
        .overlay(VStack{Divider().background(underlineColor).offset(x: 0, y: 20)})
       
    }
    

}

extension Common {
    
    
    static func topBar(title : String, switchToViewType : Binding <FMM.ViewType>, switchToView : FMM.ViewType = .menu) -> some View {
     
        HStack {
      
            Text(title.localized).font(.custom(Theme.fontNameBold, size: 30)).padding()
            .foregroundColor(.black)
         
            Spacer()
            
            Button(action: {
              
                withAnimation{
          
                    switchToViewType.wrappedValue = switchToView
              
                }
            }){
      
                Image("close").resizable().frame(width: 24, height:24)//.colorInvert()
            }
            
            Spacer().frame(width:10)
        }
      
    }
    
    
    static func topBar(title : String, switchToViewType : Binding <MV.ViewType>) -> some View {
     
        HStack {
      
            Text(title.localized).font(.custom(Theme.fontNameBold, size: 30)).padding()
            .foregroundColor(.black)
         
            Spacer()
            
            Button(action: {
              
                withAnimation{
          
                    switchToViewType.wrappedValue = .none
              
                }
            }){
      
                Image("close").resizable().frame(width: 24, height:24)//.colorInvert()
            }
            
            Spacer().frame(width:10)
        }
      
    }
    
    
    static func buttonView(imageSysteName : String) -> some View {
        
        
        ZStack {
            
            Circle().fill(Color(UIColor(hex:"#228855ff")!)).frame(width: 30, height: 30)
            .opacity(0.7)
                
            Image(systemName: imageSysteName).resizable().frame(width: 16, height: 16).foregroundColor(.white)

        }
    }
    
    
    
    
    
    static func buttonView(_ name : String, imageColorInvert : Bool = false ) -> some View {
        
        
        ZStack {
            
            Circle().fill(Color(UIColor(hex:"#228855ff")!)).frame(width: 30, height: 30)
            .opacity(0.7)
                
            if imageColorInvert {
            
                Image(name).resizable().frame(width: 16, height: 16).colorInvert()
                
            }
            else {
                
                Image(name).resizable().frame(width: 16, height: 16)
            }
            
        }
    }
}

extension Common {
    
    static func isIPad() -> Bool {
        
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
