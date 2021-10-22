
import Foundation

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var uriTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To hide the done button above the keyboard
        keyTextField.inputAccessoryView = UIView()
        secretTextField.inputAccessoryView = UIView()
        uriTextField.inputAccessoryView = UIView()
        
        keyTextField.delegate = self
        secretTextField.delegate = self
        uriTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Settings"
        
        keyTextField.text = StoredSetting.key
        secretTextField.text = StoredSetting.secret
        uriTextField.text = StoredSetting.uri
        keyTextField.isSecureTextEntry = true
        secretTextField.isSecureTextEntry = true
    }
    
    // MARK:- Actions
    @IBAction func saveAction(_ sender: UIButton) {
        StoredSetting.key = keyTextField.text
        StoredSetting.secret = secretTextField.text
        StoredSetting.uri = uriTextField.text
        
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SettingsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == keyTextField {
            if textField.text == "\n" {
                secretTextField.becomeFirstResponder()
                return false
            }
        } else if textField == secretTextField {
            if textField.text == "\n" {
                uriTextField.becomeFirstResponder()
                return false
            }
        } else {
            if textField.text == "\n" {
                textField.resignFirstResponder()
                return false
            }
        }
        return true
    }
}

