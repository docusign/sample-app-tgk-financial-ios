import UIKit

protocol AlertPresentable {
    func showAlert(message: String)
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(message: String) {
        let title = String.developerNotesTitle(with: true)
        let syncAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        syncAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(syncAlert, animated: true, completion: nil)
    }
}
