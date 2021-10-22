
import UIKit

class PortfolioVC: UIViewController {
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var datedLabel: UILabel!
    @IBOutlet weak var chartImageView: UIImageView!
    var client: ClientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fName = client.firstName, let lName = client.lastName, let status = client.status, let dated = client.datedDoc {

            creatorNameLabel.text = "\(fName) \(lName)"
            statusLabel.text = status
            datedLabel.text = dated
        }
    }
    
    @IBAction func agreementAction(_ sender: UIButton) {
        
        let viewAgreementVC = VCFactory.createViewAgreementVC(with: client)
        navigationController?.pushViewController(viewAgreementVC, animated: true)
    }
}
