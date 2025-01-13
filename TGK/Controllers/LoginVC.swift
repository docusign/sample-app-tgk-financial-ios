
import UIKit
import AuthenticationServices
import DocuSignSDK

class LogInViewController: UIViewController {
    
    @IBOutlet weak var ellipsisBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    var webAuthSession: ASWebAuthenticationSession?
    
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
        updateSignInButtonState(enabled: false)
        guard let clientId = StoredSetting.key else { return }
        guard let redirectUri = StoredSetting.uri else { return }
        guard let IK = StoredSetting.secret else { return }
        DSMManager.login(withOAuthEnv: .demo, accountId: clientId, redirectUri: redirectUri, integratorKey: IK) { accountInfo, error in
            
            guard let accountInfo else { return }
            Keychain.set(accountInfo.accessToken, forKey: KeychainKeys.token)
            Keychain.set(accountInfo.email, forKey: KeychainKeys.accountEmail)
            Keychain.set(accountInfo.accountId, forKey: KeychainKeys.accountId)
            Keychain.set(accountInfo.userName, forKey: KeychainKeys.signerName)
            Keychain.set(accountInfo.host.absoluteString, forKey: KeychainKeys.baseUrl)
            
            self.updateSignInButtonState(enabled: true)
            if let error = error {
                print("Error logging in: \(error)")
            } else {
                print("User authenticated")
                let homeVC = VCFactory.createHomeVC()
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
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
        
        DSMManager.login(withAccessToken: accessToken, accountId: accountId, userId: userId, userName: userName, email: email, host: hostURL, integratorKey: integratorKey, refreshToken: nil, expiresIn: nil) { [weak self] accountInfo, error in
            
            self?.updateSignInButtonState(enabled: true)
            if let error = error {
                print("Error logging in: \(error)")
            } else {
                print("User authenticated")
                let homeVC = VCFactory.createHomeVC()
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }
}

extension LogInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
