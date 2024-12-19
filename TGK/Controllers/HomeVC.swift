
import UIKit
import DocuSignSDK

protocol CustomAppearingProtocol: AnyObject {
    func didShow()
}

class HomeVC: UIViewController {

    @IBOutlet var overview: UIView!
    @IBOutlet var templates: UIView!
    @IBOutlet var pendingSync: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    weak var pendVC: CustomAppearingProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(playTapped))
        view.bringSubviewToFront(overview)
    }
    
    
    @objc func playTapped()  {
        DSMManager.logout()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func switchScreens(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            view.bringSubviewToFront(overview)
        } else if sender.selectedSegmentIndex == 1 {
            view.bringSubviewToFront(pendingSync)
            pendVC?.didShow()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PendVC" {
            pendVC = segue.destination as? CustomAppearingProtocol
        }
    }
}
