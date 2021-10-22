import UIKit

struct RequestError: Error, Codable {
    let key: String
    let message: String
}

class WebService {
    
    func getAccessToken(code: String, completionHandler: @escaping (Result<AccessTokenResponse, RequestError>) -> Void) {
        let parameters = [
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        guard let secret = StoredSetting.secret else { return }
        guard let key = StoredSetting.key else { return }
        let basic = key + ":" + secret
        
        let headers = [
            "Authorization" : "Basic \(basic.toBase64())"
        ]
        
        request(APIRouter.accessToken, method: "POST", parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
    
    func getUserInfo(accessToken: String, completionHandler: @escaping (Result<UserInfoResponse, RequestError>) -> Void) {
        let headers = [
            "Authorization" : "Bearer \(accessToken)"
        ]
        
        request(APIRouter.userInfo, method: "GET", parameters: nil, headers: headers, completionHandler: completionHandler)
    }
    
    // BASE
    func request<T:Codable>(_ url: APIRoute,
                            method: String,
                            parameters: [String:Any]?,
                            headers: [String:String],
                            completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        
        request(url, method: method, parameters: parameters, headers: headers, attempt: 1, completionHandler: completionHandler)
    }

    func request<T:Codable>(_ url: APIRoute,
                            method: String,
                            parameters:[String:Any]?,
                            headers: [String: String],
                            attempt: Int,
                            completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        guard let convertedURL = URL(string: url.URLString) else { return }
        var request = URLRequest(url: convertedURL)
        request.httpMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let parameters = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("error = \(error) from url = \(url)")
                DispatchQueue.main.async {
                    let error = RequestError(key: "network.error", message: error.localizedDescription)
                    completionHandler(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if (500 ..< 600).contains(statusCode) {
                    if attempt < 5 {
                        print("retrying request... attempt=\(attempt + 1)")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { [weak self] in
                            self?.request(url, method: method, parameters: parameters, headers: headers, attempt: (attempt + 1), completionHandler: completionHandler)
                        }
                    } else {
                        print("retrying request... attempt=\(attempt) FAILED = \(url)")
                        DispatchQueue.main.async {
                            let error = RequestError(key: "request.failed", message: "Request failed after 5 attempts")
                            completionHandler(.failure(error))
                        }
                    }
                    return
                }
                if (400 ..< 500).contains(statusCode) {
                    let error = RequestError(key: "request.failed", message: "Client error")
                    completionHandler(.failure(error))
                    return
                }
            }
        
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    print("Parsing error: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    let error = RequestError(key: "missing.response", message: "Invalid server response")
                    completionHandler(.failure(error))
                }
                return
            }
        }.resume()
    }
    
    func createEnvelope(accessToken: String, completionHandler: @escaping (Result<EnvelopeInfo, RequestError>) -> Void) {
        let headers = [
            "Authorization" : "Bearer \(accessToken)",
            "Content-Type" : "application/json"
        ]
        
        let parameters: [String: Any] = [
            "status": "sent",
            "documents" : [[ "documentId" : "1",
                             "fileExtension" : "pdf",
                             "documentBase64" : "JVBERi0xLjcNCiWhs8XXDQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIgL0Fjcm9Gb3JtPDwvRmllbGRzW10+Pj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8L1R5cGUvUGFnZXMvQ291bnQgMS9LaWRzWyA0IDAgUiBdPj4NCmVuZG9iag0KMyAwIG9iag0KPDwvUHJvZHVjZXIoRm94aXQgUmVhZGVyIC0gRm94aXQgQ29ycG9yYXRpb24pL0F1dGhvcihkZXdleS53YWxkKS9UaXRsZShVbnRpdGxlZCkvQ3JlYXRpb25EYXRlKEQ6MjAxNDA0MTgxNDAyNDkpL01vZERhdGUoRDoyMDE0MDQxODE0MDk0Ny0wOCcwMCcpPj4NCmVuZG9iag0KNCAwIG9iag0KPDwvVHlwZS9QYWdlL1BhcmVudCAyIDAgUiAvTWVkaWFCb3hbIDAgMCA2MTIgNzkyXS9Dcm9wQm94WyAwIDAgNjEyIDc5Ml0vUmVzb3VyY2VzPDw+Pj4+DQplbmRvYmoNCnhyZWYNCjAgNQ0KMDAwMDAwMDAwMCA2NTUzNiBmDQowMDAwMDAwMDE3IDAwMDAwIG4NCjAwMDAwMDAwODggMDAwMDAgbg0KMDAwMDAwMDE0NCAwMDAwMCBuDQowMDAwMDAwMzA5IDAwMDAwIG4NCnRyYWlsZXINCjw8DQovUm9vdCAxIDAgUg0KL0luZm8gMyAwIFINCi9TaXplIDUvSURbKDRTujhI0ARF4C/SqXmlVXcpKDRTujhI0ARF4C/SqXmlVXcpXT4+DQpzdGFydHhyZWYNCjQxNQ0KJSVFT0YNCg==",
                             "name": "blank.pdf"
            ]],
            "emailSubject": "one recipient envelope",
            "emailBlurb": "one recipient envelope",
            "recipients": [
                "signers": [
                    [
                        "tabs": [
                            "initialHereTabs": [
                                [
                                    "yPosition": "100",
                                    "documentId": "1",
                                    "pageNumber": "1",
                                    "xPosition": "200"
                                ]
                            ],
                            "signHereTabs": [
                                [
                                    "yPosition": "100",
                                    "documentId": "1",
                                    "pageNumber": "1",
                                    "xPosition": "100"
                                ]
                            ]
                        ],
                        "email": "thomas_template_demo@dsxtr.com",
                        "clientUserId": "1",
                        "recipientId": "1",
                        "routingOrder": "1",
                        "name": "Triston Gilbert",
                        "requireIdLookup": "false"
                    ]
                ]
            ]
        ]
        
        let accountId: String = Keychain.value(forKey: KeychainKeys.accountId)!
        let url = "https://demo.docusign.net/restapi/v2.1/accounts/\(accountId)/envelopes"
        
        request(url, method: "POST", parameters: parameters, headers: headers, completionHandler: completionHandler)
    }
}
