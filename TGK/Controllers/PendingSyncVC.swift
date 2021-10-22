
import UIKit

class PendingSyncVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var noPendingDocsLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var pendingSyncDocs = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        refreshView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SyncEnded),
            name: NSNotification.Name(rawValue: "DSMEnvelopeSyncingEndedNotification"),
            object: nil)
    }
    
    @IBAction func syncButtonTapped(_ sender: Any) {
        EnvelopesManager.shared.syncEnvelopes()
        EnvelopesManager.shared.mDSMEnvelopesManager?.syncEnvelopes()
        syncButton.isEnabled = false
        activityIndicatorView.startAnimating()
    }
    
    @objc func SyncEnded() {
        DispatchQueue.main.async {
            self.syncButton.isEnabled = true
            self.activityIndicatorView.stopAnimating()
            self.refreshView()
        }
    }
    
    @objc func refreshView() {
        pendingSyncDocs = EnvelopesManager.shared.getCachedEnvelopeIds() ?? []
        if pendingSyncDocs.isEmpty {
            tableView.isHidden = true
            syncButton.isHidden = true
            noPendingDocsLabel.isHidden = false
        } else {
            tableView.isHidden = false
            syncButton.isHidden = false
            noPendingDocsLabel.isHidden = true
            tableView.reloadData()
        }
    }
}

extension PendingSyncVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingSyncDocs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendIdentifier", for: indexPath)
        
        if !pendingSyncDocs.isEmpty {
            let doc = pendingSyncDocs[indexPath.row]
            cell.textLabel?.text = doc
        }
        return cell
    }
}

extension PendingSyncVC: CustomAppearingProtocol {
    func didShow() {
        refreshView()
    }
}

extension PendingSyncVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


