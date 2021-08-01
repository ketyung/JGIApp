//
//  TemplateView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//


import SwiftUI
import UIKit
import DocuSignSDK

struct DocuSignTemplateView : UIViewControllerRepresentable {

    private var templatesManager: DSMTemplatesManager?
      
    
    init(){
        
        templatesManager = DSMTemplatesManager()
    }
    
    
    
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocuSignTemplateView>) -> UIViewController {
        
       let controller = UIViewController()
        
        self.displayTemplateForSignature(templateId: "xxxxx", controller: controller, tabData: ["text" : "test"], recipientData: [], customFields: nil, onlineSign: true, attachmentUrl: nil, completionHandler: {
            
            c, err in
            
            if let err = err {
                
                print("error::\(err)")
            }
        })
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<DocuSignTemplateView>) {

        
    }
    
    
}

extension DocuSignTemplateView {
    
    private func displayTemplateForSignature(templateId: String, controller: UIViewController, tabData: Dictionary<String, String>, recipientData: Array<DSMRecipientDefault>, customFields:DSMCustomFields?, onlineSign: Bool,
        attachmentUrl: URL?,
        completionHandler: ((UIViewController?, Error?) -> Void)? = nil)
    {
        // load PDF data
        var pdfData: Data?
        if (attachmentUrl != nil)
        {
            do {
                pdfData = try Data(contentsOf: attachmentUrl!)
            }
            catch {
                NSLog("Error loading PDF data")
            }
        }
        
        let envelopeDefaults = DSMEnvelopeDefaults()
        envelopeDefaults.recipientDefaults = recipientData.count > 0 ? recipientData : nil
        envelopeDefaults.tabValueDefaults = tabData
        envelopeDefaults.customFields = customFields
        
        templatesManager?.presentSendTemplateControllerWithTemplate (
            withId: templateId,
            envelopeDefaults: envelopeDefaults,
            pdfToInsert: pdfData,
            insertAtPosition: .end,
            signingMode: onlineSign ? .online : .offline,
            presenting: controller,
            animated: true) { (view, error) in
                if let error = error {
                    NSLog("Error encountered during signing: \(error.localizedDescription)")
                }
                if view == nil {
                    // `view` is `nil` if all of the signers pending for signature are remote
                    // A) Envelope is sent to next remote signer, should receive `DSMSigningCompletedNotification` during online signing.
                    // B) Or in case of offline signing, envelope is successfully cached and now awaiting sync.
                    NSLog("Warning: Encountered `nil view` during signing.")
                } else {
                    // DocuSign SDK UI components are active if >=1 local signers are pending signature
                    NSLog("DocuSign Native iOS SDK - UI components active")
                }
        }
    }
}
