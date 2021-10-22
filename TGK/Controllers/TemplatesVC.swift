
import UIKit

class TemplatesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let templates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if templates.isEmpty {
            tableView.isHidden = true
            
            let notificationLabel = EmptyDataLabel(sourceView: tableView)
            notificationLabel.text = "No available Templates"
            view.addSubview(notificationLabel)
        }
    }
}
