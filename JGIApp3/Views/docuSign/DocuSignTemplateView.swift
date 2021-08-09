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
      
    @EnvironmentObject private var signingViewModel : CFSVM
    
    //private let recipientData = ""
    
    
    init(){
        
        templatesManager = DSMTemplatesManager()
    }
    
    
    
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocuSignTemplateView>) -> UIViewController {
        
       let controller = UIViewController()
        
        self.displayTemplateForSignature(templateId: "e3394e8c-b989-4d36-bf50-6420f5fd69c8",
        controller: controller, tabData: ["text" : "test"], recipientData: defaultReceipients(),
        customFields: nil, onlineSign: true, pdfData: signingViewModel.attachment, completion: { c, err in
            
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



struct DocuSignError : LocalizedError, CustomStringConvertible {
    
    var errorText : String?
    
    public var description: String {
        
        "\(errorText ?? "Unknown error".localized)"
    }

    public var errorDescription : String {
        
        errorText ?? "Unknown error".localized
    }
}


extension DocuSignTemplateView {
    
    private func displayTemplateForSignature(templateId: String, controller: UIViewController, tabData: Dictionary<String, String>, recipientData: Array<DSMRecipientDefault>, customFields:DSMCustomFields?,
        onlineSign: Bool, pdfData : Data? ,
        completion: ((UIViewController?, Error?) -> Void)? = nil)
    {
        
        guard let pdfData = pdfData else {
        
            completion?(nil, DocuSignError(errorText: "No PDF data!"))
            
            return
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
            animated: true) { view, error in
                if let error = error {
               
                    print("DocuSign.error::\(error)")
                    
                    completion?(nil, error)
                    return
                }
            
                if view == nil {
                    // `view` is `nil` if all of the signers pending for signature are remote
                    // A) Envelope is sent to next remote signer, should receive `DSMSigningCompletedNotification` during online signing.
                    // B) Or in case of offline signing, envelope is successfully cached and now awaiting sync.
                    //NSLog("Warning: Encountered `nil view` during signing.")
                    
                    completion?(nil, DocuSignError(errorText: "Nil viewcontroller"))
                } else {
                    // DocuSign SDK UI components are active if >=1 local signers are pending signature
                    //NSLog("DocuSign Native iOS SDK - UI components active")
                    
                    completion?(view, nil)
                }
        }
    }
}


extension DocuSignTemplateView {
    
    private func defaultReceipients() -> [DSMRecipientDefault] {
        
        let recipientDatum = DSMRecipientDefault()
        // Use recipient roleName (other option to use recipient-id) to find unique recipient in the template
        recipientDatum.recipientRoleName = "GIS User"
        recipientDatum.recipientSelectorType = .recipientRoleName
        recipientDatum.recipientType = .inPersonSigner
        // In-person-signer name
        recipientDatum.inPersonSignerName = "Christopher Chee"
        // Host name (must match the name on the account) and email
        recipientDatum.recipientName = "Christopher Chee"
        recipientDatum.recipientEmail = "ketyung@gmail.com"
        return [recipientDatum]
    }
}
