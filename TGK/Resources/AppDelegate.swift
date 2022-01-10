
import UIKit
import DocuSignSDK
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        // Uncomment to initialize DS sdk manager with default configurations
        // DSMManager.setup()
        
        var configurations = DSMManager.defaultConfigurations()
        
        // hide offline signing alerts
        configurations[DSM_SETUP_OFFLINE_SIGNING_HIDE_ALERTS_KEY] = DSM_SETUP_TRUE_VALUE
        
        // if icloud is enabled, then this constant should be set to DSM_SETUP_TRUE_VALUE
        configurations[DSM_SETUP_ICLOUD_DOCUMENT_ENABLED] = DSM_SETUP_FALSE_VALUE

        // example: Disable Contacts use in the TGK app
        //configuration[DSM_SETUP_DISABLE_CONTACTS_USAGE_KEY] = DSM_SETUP_TRUE_VALUE
        
        // initialize DS sdk manager
        DSMManager.setup(withConfiguration: configurations)
        
        return true
    }
}

