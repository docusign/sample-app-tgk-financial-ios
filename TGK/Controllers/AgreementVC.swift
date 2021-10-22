
import UIKit

class AgreementVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var contactView: UIView!
    var clientFile: ClientModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(portfolioView)
    }
    
    
    @IBAction func switchScreen(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            view.bringSubviewToFront(portfolioView)
        } else {
            view.bringSubviewToFront(contactView)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PortfolioVC" {
            let portfolioVC = segue.destination as! PortfolioVC

            portfolioVC.client = clientFile
        } else {
            let contactVC = segue.destination as! ContactVC
            contactVC.client = clientFile
        }
    }
}
