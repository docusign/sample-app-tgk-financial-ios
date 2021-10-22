
import UIKit

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
