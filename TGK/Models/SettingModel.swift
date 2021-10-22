
import Foundation

struct StoredSetting {
    
    static var key: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "key")
        }
        get {
            return UserDefaults.standard.value(forKey: "key") as? String
        }
    }
    
    static var secret: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "secret")
        }
        get {
            return UserDefaults.standard.value(forKey: "secret") as? String
        }
    }

    
    static var uri: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "uri")
        }
        get {
            return UserDefaults.standard.value(forKey: "uri") as? String
        }
    }
}
