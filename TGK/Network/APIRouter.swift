import UIKit

private let baseURL = "https://account-d.docusign.com/"

protocol APIRoute {
    var URLString: String { get }
}

extension String: APIRoute {
    var URLString: String {
        return self
    }
}

enum APIRouter: APIRoute {
    case accessToken
    case userInfo
    
    var URLString: String {
        
        
        
        let path: String = {
            switch self {
            case .accessToken:
                return "oauth/token"
            case .userInfo:
                return "oauth/userinfo"
            }
        }()
        
        return baseURL + path
    }
}
