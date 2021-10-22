
import UIKit
import AuthenticationServices
import DocuSignSDK

class LogInViewController: UIViewController {
    
    @IBOutlet weak var ellipsisBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    var webAuthSession: ASWebAuthenticationSession?
    
    let webService = WebService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ellipsisAction(_ sender: UIBarButtonItem) {
        let settingsVC = VCFactory.createSettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @IBAction func signInAction(_ sender: UIButton) {
        guard let key = StoredSetting.key, !key.isEmpty, let secret = StoredSetting.secret, !secret.isEmpty, let uri = StoredSetting.uri, !uri.isEmpty else {
            let alert = UIAlertController.init(title: "Settings not Saved", message: "Please open the settings screen and save the Auth settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        getAuthTokenWithWebLogin()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
       // TODO: enter registration screen from WEB
    }
    
    func getAuthTokenWithWebLogin() {
        guard let clientId = StoredSetting.key else { return }
        guard let redirectUri = StoredSetting.uri else { return }
        updateSignInButtonState(enabled: false)
        let authURL = URL(string: "https://account-d.docusign.com/oauth/auth?response_type=code&scope=signature&client_id=\(clientId)&redirect_uri=\(redirectUri)")
        let callbackUrlScheme = redirectUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { [weak self] (callBack:URL?, error:Error?) in

            guard error == nil, let successURL = callBack else {
                self?.updateSignInButtonState(enabled: true)
                return
            }

            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            guard let code = oauthToken?.value else { return }
            
            self?.webService.getAccessToken(code: code) { result in
                switch result {
                case .failure(let error):
                    self?.updateSignInButtonState(enabled: true)
                    print(error)
                case .success(let data):
                    let accessToken = data.accessToken
                
                    Keychain.set(accessToken, forKey: KeychainKeys.token)

                    self?.webService.getUserInfo(accessToken: accessToken) { result in
                        switch result {
                        case .failure(let error):
                            self?.updateSignInButtonState(enabled: true)
                            print(error)
                        case .success(let data):
                            let accountInfo = data.accounts[0]
                            guard let key = StoredSetting.key else { return }
                            
                            let email = data.email
                            let recipientId = accountInfo.accountId
                            let signerName = accountInfo.accountName
                            
                            Keychain.set(email, forKey: KeychainKeys.accountEmail)
                            Keychain.set(recipientId, forKey: KeychainKeys.accountId)
                            Keychain.set(signerName, forKey: KeychainKeys.signerName)
                            
                            self?.login(accessToken: accessToken,
                                        accountId: accountInfo.accountId,
                                        userId: data.sub,
                                        userName: accountInfo.accountName,
                                        email: data.email,
                                        integratorKey: key)
                        }
                    }
                }
            }
        })

        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.prefersEphemeralWebBrowserSession = true

        self.webAuthSession?.start()
    }
    
    func updateSignInButtonState(enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                self.loginActivity.stopAnimating()
            } else {
                self.loginActivity.startAnimating()
            }
            self.signInButton.isEnabled = enabled
        }
    }
    
    func login(accessToken: String,
               accountId: String,
               userId: String,
               userName: String,
               email: String,
               host: String = "https://demo.docusign.net/restapi",
               integratorKey: String) {
        guard let hostURL = URL(string: host) else { return }
        DSMManager.login(withAccessToken: accessToken, accountId: accountId, userId: userId, userName: userName, email: email, host: hostURL, integratorKey: integratorKey) { [weak self] accountInfo, error in
            
            self?.updateSignInButtonState(enabled: true)
            if let error = error {
                print("Error logging in: \(error)")
            } else {
                print("User authenticated")
                let homeVC = VCFactory.createHomeVC()
                self?.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
}

extension LogInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
