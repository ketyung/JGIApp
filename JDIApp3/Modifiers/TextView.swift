//
//  TextView.swift
//  TzWallet
//
//  Created by Chee Ket Yung on 26/07/2021.
//

import SwiftUI

struct TextView : UIViewRepresentable {
    
    @Binding var text : String
    
    @Binding var isFirstResponder : Bool
    
    var backgroundColor : UIColor = UIColor(hex: "#ddddeeff")!
    
    var foregroundColor : UIColor = .white
    
    var fontName : String = Theme.fontName
    
    var fontSize : CGFloat = 16
   
    var autocapitalization : UITextAutocapitalizationType = .none
    
    var autocorrection : UITextAutocorrectionType = .default
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: fontName, size: fontSize)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = backgroundColor
        myTextView.textColor = foregroundColor
        myTextView.autocapitalizationType = autocapitalization
        myTextView.autocorrectionType = autocorrection
        
        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
         //   print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            self.parent.isFirstResponder = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            self.parent.isFirstResponder = false
        }
    }
}
