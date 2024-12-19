
import UIKit
import DocuSignSDK

class OverviewVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartImage: UIImageView!

    let files = Clients().createdFakeClientData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if files.count == 0 {
            tableView.alpha = 0
            let notificationLabel = EmptyDataLabel(sourceView: tableView)
            notificationLabel.text = "No available investment presentation"
            view.addSubview(notificationLabel)
        }
        
        tableView.register(UINib(nibName: "OverviewDocCell", bundle: nil), forCellReuseIdentifier: "OverviewDocCell")
    }
    
    @IBAction func executeAPIButtonTapped(_ sender: Any) {
        let basePath: String = Keychain.value(forKey: KeychainKeys.baseUrl)! // Base path for API calls (demo/prod)
        if let accountId: String = Keychain.value(forKey: KeychainKeys.accountId){ // Param needed for API call
            
            // Initializing the API client with the access token and base url
            DSClientAPI.init(basePath: basePath , customHeaders: [:])
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.center = self.view.center
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            // Picking the needed api call and providing the needed params for this api call
            AccountsAPI.accountsGetAccount(accountId: accountId, includeAccountSettings: nil, completion: { data, error in
                activityIndicator.stopAnimating()
                //completion handling for error and sucess of request
                if let error = error {
                    let message = error.localizedDescription
                    let alert = UIAlertController(title: "Request failed", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error)
                }
                else {
                    let message = "AccountName: \(String(describing: data?.accountName))\n PlanName: \(String(describing: data?.planName))"
                    let alert = UIAlertController(title: "Request Successful", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(message)
                }
            })
        }
    }
}

extension OverviewVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let agreementVC = VCFactory.createAgreementVC(with: files[indexPath.row])
        
        navigationController?.pushViewController(agreementVC, animated: true)
    }
}

extension OverviewVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewDocCell", for: indexPath) as! OverviewDocCell
        
        if !files.isEmpty {
            let clientFile = files[indexPath.row]

            if let fName = clientFile.firstName, let lName = clientFile.lastName, let status = clientFile.status, let dated = clientFile.datedDoc  {
                cell.nameLabel.text = "\(fName) \(lName)"
                cell.dateLabel.text = "\(dated) (Tap to sign)"
                cell.statusLabel.text = status
            }
        }
        return cell
    }
}
