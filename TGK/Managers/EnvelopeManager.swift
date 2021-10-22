
import DocuSignSDK
import Foundation


class EnvelopesManager {
    // singleton instance
    static let shared = EnvelopesManager()

    // DSM Envelopes Manager
    var mDSMEnvelopesManager: DSMEnvelopesManager?
    
    // list of template definitions
    var mEnvelopeDefinitions: [DSMEnvelopeDefinition]?

    //This prevents others from using the default '()' initializer for this class.
    private init() {
        if (self.mDSMEnvelopesManager == nil)
        {
            self.mDSMEnvelopesManager = DSMEnvelopesManager()
            NotificationCenter.default.addObserver(self, selector: #selector(handleDSMSigningCompletedNotification(notification:)), name: NSNotification.Name.DSMSigningCompleted, object: nil)
        }
    }
    

    func getCachedEnvelopeIds() -> [String]? {
        return self.mDSMEnvelopesManager?.cachedEnvelopeIds()
    }


    func syncEnvelopes() -> Void {
        self.mDSMEnvelopesManager?.syncEnvelopes()
    }
    
    @objc func handleDSMSigningCompletedNotification(notification: Notification) {
        syncEnvelopes()
    }
    
    func composeEnvelopeOffline(presentingController: UIViewController) {
        
        let tabBuilder = DSMTabBuilder(for: .signHere)
        tabBuilder.addName("Signature")
        tabBuilder.addDocumentId("1")
        
        let recipientId: String = "1"
        tabBuilder.addRecipientId(recipientId)
        tabBuilder.addFrame(CGRect(x: 100, y: 100, width: 50, height: 50))
        tabBuilder.addPageNumber(1)
        
        let recipientBuilder = DSMRecipientBuilder(for: .signer)
        let recipientEmail: String = Keychain.value(forKey: KeychainKeys.accountEmail)!
        let signerName: String = Keychain.value(forKey: KeychainKeys.signerName)!
        recipientBuilder.addSignerEmail(recipientEmail)
        recipientBuilder.addRecipientId(recipientId)
        recipientBuilder.addSignerName(signerName)
        recipientBuilder.add(tabBuilder.build())
        
        let documentBuilder = DSMDocumentBuilder()
        documentBuilder.addName("Document")
        documentBuilder.addDocumentId("1")
        documentBuilder.addFilePath(Bundle.main.path(forResource: "Portfolio", ofType: "pdf")!)
        
        let envelopeBuilder = DSMEnvelopeBuilder()
        envelopeBuilder.add(recipientBuilder.build())
        envelopeBuilder.addEnvelopeName("DocuSign")
        envelopeBuilder.addEmailSubject("DocuSign.pdf")
        envelopeBuilder.addEmailMessage("Hi, I'm sending you a document to sign and return, ....")
        envelopeBuilder.add(documentBuilder.build())
        
        let envelope = envelopeBuilder.build()
        
        mDSMEnvelopesManager?.composeEnvelope(with: envelope, signingMode: .offline, completion: { envelopeId, error in
            
            if let id = envelopeId {
                // offline
                self.mDSMEnvelopesManager?.resumeSigningEnvelope(withPresenting: presentingController, envelopeId: id, completion: { _, _ in })
            } else {
                // online
                self.showAlert(presentingController: presentingController, message: error.localizedDescription)
            }
        })
    }
    
    private func showAlert(presentingController: UIViewController, message: String) {
        let title = String.developerNotesTitle(with: true)
        let syncAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add Ok action
        syncAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        presentingController.present(syncAlert, animated: true, completion: nil)
    }
}
