//
//  TemplateView.swift
//  JDIApp2
//
//  Created by Chee Ket Yung on 01/08/2021.
//


import SwiftUI
import UIKit
import DocuSignSDK

struct DocuSignSigningView  : UIViewControllerRepresentable {

    private var templatesManager: DSMTemplatesManager?
      
    @EnvironmentObject private var signingViewModel : SVM
  
    
    init(){
        
        templatesManager = DSMTemplatesManager()
        
    }
    
    
    
    
    public func makeUIViewController(context:
    UIViewControllerRepresentableContext<DocuSignSigningView >) -> DocuSignViewController {
        
       let controller = DocuSignViewController()
        
        /** signingViewModel.attachment */
        
        self.displayTemplateForSignature(templateId: signingViewModel.templateId ,
        controller: controller, tabData: tabData(), recipientData: receipients(),
        customFields: nil, onlineSign: true, pdfData:  nil , completion: { c, err in
            
            
            guard let _ = c else {
                
                return
            }
            
            if let err = err {
                
                withAnimation{
          
                    signingViewModel.errorMessage = err.localizedDescription
                    signingViewModel.errorPresented = true
              
                }
            }
           
            
          
        })
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: DocuSignViewController,
                                context: UIViewControllerRepresentableContext<DocuSignSigningView >) {

        
    }
    
    
}


class DocuSignViewController : UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
     
}



/***/
struct DocuSignError : LocalizedError, CustomStringConvertible {
    
    var errorText : String?
    
    public var description: String {
        
        "\(errorText ?? "Unknown error".localized)"
    }

    public var errorDescription : String {
        
        errorText ?? "Unknown error".localized
    }
}


extension DocuSignSigningView  {
    
    private func displayTemplateForSignature(templateId: String, controller: UIViewController, tabData: Dictionary<String, String>, recipientData: Array<DSMRecipientDefault>, customFields:DSMCustomFields?,
        onlineSign: Bool, pdfData : Data? ,
        completion: ((UIViewController?, Error?) -> Void)? = nil)
    {
       
        
        signingViewModel.registerForSigningCompletion()
        
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
               
                    print("DocuSign.error::\(error)::tmpId::\(templateId)")
                    
                    completion?(nil, error)
                    return
                }
            
                if view == nil {
                    // `view` is `nil` if all of the signers pending for signature are remote
                    // A) Envelope is sent to next remote signer, should receive `DSMSigningCompletedNotification` during online signing.
                    // B) Or in case of offline signing, envelope is successfully cached and now awaiting sync.
                    //NSLog("Warning: Encountered `nil view` during signing.")
                    
                    completion?(nil, DocuSignError(errorText: "Nil viewcontroller"))
                }
                else {
                    // DocuSign SDK UI components are active if >=1 local signers are pending signature
                    //NSLog("DocuSign Native iOS SDK - UI components active")
                    
                    completion?(view, nil)
                }
        }
    }
}


extension DocuSignSigningView  {
    
    private func tabData() -> [String : String] {
        
        return ["versionNo" : "\(signingViewModel.versionNo)", "mapId" : signingViewModel.mapId]
    }
    
    private func receipients() -> [DSMRecipientDefault] {
        
        
        var recipientsData =  [DSMRecipientDefault]()
        
        signingViewModel.recipients.forEach{
            
            recipient in
    
            let recipientDatum = DSMRecipientDefault()
            recipientDatum.recipientRoleName = recipient.groupName ?? ""
            recipientDatum.recipientSelectorType = .recipientRoleName
            recipientDatum.recipientType = .inPersonSigner
            // In-person-signer name
            recipientDatum.inPersonSignerName = recipient.name ?? ""
            // Host name (must match the name on the account) and email
            recipientDatum.recipientName = recipient.name ?? ""
            recipientDatum.recipientEmail =  recipient.email ?? ""
            
            recipientsData.append(recipientDatum)
            
        }
        
        return recipientsData
    }
}
