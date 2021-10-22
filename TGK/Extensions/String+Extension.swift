
import Foundation
import DocuSignSDK

extension String {
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    static func developerNotesTitle(with sdkVersion:Bool) -> String {
        return sdkVersion ? "Developer's Notes (\(DSMManager.buildVersion()))" : "Developer's Notes"
    }
}
