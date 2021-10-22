
import UIKit
import DocuSignSDK
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        var configurations = DSMManager.defaultConfigurations()
                // hide offline signing alerts
        configurations[DSM_SETUP_OFFLINE_SIGNING_HIDE_ALERTS_KEY] = DSM_SETUP_TRUE_VALUE
        
        if #available(iOS 11.0, *) {
            // icloud entitlement is not required for iOS 11+ - set constant to true to enable document picker usage
            configurations[DSM_SETUP_ICLOUD_DOCUMENT_ENABLED] = DSM_SETUP_TRUE_VALUE
        } else {
            // icloud entitlement (icloud documents) is required for iOS 10 and below for document picker usage
            // if icloud is enabled, then this constant should be set to DSM_SETUP_TRUE_VALUE
            configurations[DSM_SETUP_ICLOUD_DOCUMENT_ENABLED] = DSM_SETUP_FALSE_VALUE
        }
        
        //configuration[DSM_SETUP_DISABLE_CONTACTS_USAGE_KEY] = DSM_SETUP_TRUE_VALUE
        
        //configuration[DSM_SETUP_OFFLINE_SIGNING_USE_PLACEHOLDER_TAB_VALUE] = DSM_SETUP_FALSE_VALUE
        // initialize DS sdk manager
        DSMManager.setup(withConfiguration: configurations)
        
        return true
    }
}

