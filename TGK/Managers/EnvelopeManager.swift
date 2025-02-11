
import DocuSignSDK
import DocusignNative
import Foundation

class TGKColors {
    public static let navigationBackButtonTintColor = UIColor.blue
    public static let background = UIColor.black
    public static let foreground = UIColor.white
}

class EnvelopesManager {
    // singleton instance
    static let shared = EnvelopesManager()

    // DSM Envelopes Manager
    var mDSMEnvelopesManager: DSMEnvelopesManager?
    var mDSMTemplatesManager: DSMTemplatesManager?
    var mNativeSigningManager: NativeSigningManager?
    
    // list of template definitions
    var mEnvelopeDefinitions: [DSMEnvelopeDefinition]?

    //This prevents others from using the default '()' initializer for this class.
    private init() {
        if (self.mDSMEnvelopesManager == nil) {
            self.mDSMEnvelopesManager = DSMEnvelopesManager()
            NotificationCenter.default.addObserver(self, selector: #selector(handleDSMSigningCompletedNotification(notification:)), name: NSNotification.Name.DSMSigningCompleted, object: nil)
        }
        
        if (self.mDSMTemplatesManager == nil) {
            self.mDSMTemplatesManager = DSMTemplatesManager()
        }
        
        if (self.mNativeSigningManager == nil) {
            self.mNativeSigningManager = NativeSigningManager()
        }
    }
    

    func getCachedEnvelopeIds() -> [String]? {
        return self.mDSMEnvelopesManager?.cachedEnvelopeIds()
    }
    
    func sendTemplateOffline(templateId: String, presentingVC: UIViewController, completion: @escaping ((UIViewController?, (any Error)?) -> Void)) -> Void {
        self.mDSMTemplatesManager?.cacheTemplate(withId: templateId) { (error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let email: String = Keychain.value(forKey: KeychainKeys.accountEmail)!
            let username: String = Keychain.value(forKey: KeychainKeys.signerName)!
            
            let envelopeDefaults = DSMEnvelopeDefaults()
            envelopeDefaults.emailBlurb = "Please sign this envelope."
            envelopeDefaults.emailSubject = "Please sign this envelope."
            
            
            let recipientDefault = DSMRecipientDefault()
            recipientDefault.recipientType = .inPersonSigner
            recipientDefault.recipientSelectorType = .recipientRoleName
            recipientDefault.recipientRoleName = "Role"
            recipientDefault.inPersonSignerName = "Signer Name"
            recipientDefault.recipientName = username
            recipientDefault.recipientEmail = email
            
            let recipientDefault2 = DSMRecipientDefault()
            recipientDefault2.recipientType = .inPersonSigner
            recipientDefault2.recipientSelectorType = .recipientRoleName
            recipientDefault2.recipientRoleName = "Role2"
            recipientDefault2.inPersonSignerName = "Signer Name2"
            recipientDefault2.recipientName = username
            recipientDefault2.recipientEmail = email
            
            envelopeDefaults.recipientDefaults = [recipientDefault, recipientDefault2]
            
            Task {
                do {
                    let vc = try await self.mNativeSigningManager?.presentSendTemplate(presentingViewController: presentingVC, templateId: templateId, envelopeDefaults: envelopeDefaults, insertAtPosition: .beginning, pdfToInsert: nil, animated: true)
                    completion(vc, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }

    func syncEnvelopes() -> Void {
        self.mDSMEnvelopesManager?.syncEnvelopes()
    }
    
    @objc func handleDSMSigningCompletedNotification(notification: Notification) {
        syncEnvelopes()
    }
        
    func offlineCacheAndSign(presentingController: UIViewController, envelopeId: String, completion: @escaping (UIViewController?, Error?) -> Void) {
        
        // `Downloading remote envelopes for offline signing` is disabled for now as this feature is in beta.
        
        // Download the remote envelope from DocuSign Server with a given envelope Id
        self.mDSMEnvelopesManager?.downloadEnvelope(withId: envelopeId) { _, error in
            
            guard error == nil else {
                // Handle error ...
                return
            }
            
            DispatchQueue.main.async {
                // Envelope download is complete, start offline signing ceremony
                self.resumeOfflineSigning(presentingViewController: presentingController, envelopeId: envelopeId, completion: completion)
            }
        }
    }
    
    func resumeOfflineSigning(presentingViewController: UIViewController, envelopeId: String, completion: @escaping (UIViewController?, Error?) -> Void) {
        // Optionally customize the Appearance to match the host app theme
        // applyAppearance()
        
        // Launch offline signing
        Task {
            do {
                let vc = try await self.mNativeSigningManager?.resumeSigning(presentingVC: presentingViewController, envelopeId: envelopeId)
                completion(vc, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func applyAppearance() {
        DSMAppearance.setNavigationBarTitleTextColor(TGKColors.navigationBackButtonTintColor)
        DSMAppearance.setNavigationBarTitleTextColor(TGKColors.foreground, backgroundTintColor: TGKColors.background, fontSize: 14)
        DSMAppearance.setBarButtonItemsTintColor(TGKColors.foreground)
    }
    
    func composeEnvelopeOffline(presentingController: UIViewController) {
        
        let tabBuilder = DSMTabBuilder(for: .signHere)
        tabBuilder.addName("Signature")
        tabBuilder.addDocumentId("1")
        
        let recipientId: String = "1"
        tabBuilder.addRecipientId(recipientId)
        tabBuilder.addFrame(CGRect(x: 400, y: 600, width: 50, height: 40))
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
                Task {
                    do {
                        let vc = try await self.mNativeSigningManager?.resumeSigning(presentingVC: presentingController, envelopeId: id)
                    } catch let error {
                        print(error)
                    }
                }
            } else {
                // online
                self.showAlert(presentingController: presentingController, message: error?.localizedDescription ?? "Can't create envelope")
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
