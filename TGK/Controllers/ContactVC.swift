
import UIKit

class ContactVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryZipCodeLabel: UILabel!
    
    var client: ClientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fName = client.firstName, let lName = client.lastName, let phone = client.phone, let email = client.email, let address = client.address, let city = client.city, let country = client.country, let zipCode = client.zipCode {
            firstLastNameLabel.text = "\(fName) \(lName)"
            phoneLabel.text = phone
            emailLabel.text = email
            addressLabel.text = address
            cityLabel.text = city
            countryZipCodeLabel.text = "\(country)-\(zipCode)"
        }
    }
}
