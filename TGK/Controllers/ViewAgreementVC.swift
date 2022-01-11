
import UIKit

class ViewAgreementVC: UIViewController {
    
    @IBOutlet weak var clientNumberTextField: UITextField!
    @IBOutlet weak var investmentAmountTextField: UITextField!
    @IBOutlet weak var checkerInvestorButton: UIButton!
    @IBOutlet weak var chartImageView: UIImageView!
    @IBOutlet weak var constraintHeightImageView: NSLayoutConstraint!
    var client: ClientModel!
    var checkerInvestorButtonSelected: Bool = false
    
    let webService = WebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        investmentAmountTextField.text = client.investmentAmount
        clientNumberTextField.text = client.clientNumber
        checkerInvestorButton.isSelected = checkerInvestorButtonSelected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard  let image = UIImage(named: "chart") else {
            return
        }
        chartImageView.image = image
        constraintHeightImageView.constant = newHeight(forSize: image.size, newWidth: chartImageView.frame.width)
        view.layoutIfNeeded()
    }
    
    // If available landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { (context) in
            self.chartImageView.alpha = 0
            
        } completion: { (context) in
            guard let image = self.chartImageView.image else {
                return
            }
            self.constraintHeightImageView.constant = self.newHeight(forSize: image.size, newWidth: self.chartImageView.frame.width)
            
            
            self.view.layoutIfNeeded()
            self.chartImageView.alpha = 1
            
        }
    }
    
    
    func  newHeight(forSize oldSize: CGSize, newWidth: CGFloat) -> CGFloat {
        return newWidth * oldSize.height / oldSize.width
    }
    
    @IBAction func investInPortfolio(_ sender: UIButton) {
    }
    
    @IBAction func actionSheet(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let threeHundred = UIAlertAction(title: "$300,000", style: .default , handler:{ (UIAlertAction)in
            //            print("User click 300,000 button")
            self.investmentAmountTextField.text = "$300,000"
        })
        let fourHundred = UIAlertAction(title: "$400,000", style: .default , handler:{ (UIAlertAction)in
            print("User click 400,000 button")
            
            self.investmentAmountTextField.text = "$400,000"
        })
        let fiveHundred = UIAlertAction(title: "$500,000", style: .default , handler:{ (UIAlertAction)in
            self.investmentAmountTextField.text = "$500,000"
        })
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(threeHundred)
        alert.addAction(fourHundred)
        alert.addAction(fiveHundred)
        alert.addAction(dismiss)
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func checkerButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            checkerInvestorButton.isSelected = false
            checkerInvestorButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            checkerInvestorButton.isSelected = true
            checkerInvestorButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        }
    }
    
    
    // MARK: private methods
    @IBAction func investInPortfolioButtonClicked(_ sender: Any) {
        let title = String.developerNotesTitle(with: true)
        let message = "Please select one of the following options"
        let agreementAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        agreementAlert.addAction(UIAlertAction(title: "Offline Compose", style: .default, handler: { _ in
            self.composeEnvelopeOffline()
        }))
        
        agreementAlert.addAction(UIAlertAction(title: "Offline Remote Envelope", style: .default, handler: { _ in
            self.signEnvelopeOffline()
        }))

        agreementAlert.addAction(UIAlertAction(title: "Captive Signing", style: .default, handler: { _ in
            self.captiveSigning()
        }))
        
        agreementAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        self.present(agreementAlert, animated: true, completion: nil)
    }
    
    func signEnvelopeOffline() {
        // Add a valid offline signing envelope Id (guid)
        let envelopeId = "<your-envelope-id-here-guid>"
        EnvelopesManager.shared.offlineCacheAndSign(presentingController: self, envelopeId: envelopeId) {_,_ in
            
        }
    }
    
    func composeEnvelopeOffline() {
        EnvelopesManager.shared.composeEnvelopeOffline(presentingController: self)
    }
    
    func captiveSigning() {
        
        guard let token: String = Keychain.value(forKey: "token") else {
            return
        }
        
        webService.createEnvelope(accessToken: token) { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let  envelopeID = data.envelopeId
                DispatchQueue.main.async {
                    EnvelopesManager.shared.mDSMEnvelopesManager?.presentCaptiveSigning(
                        withPresenting: self,
                        envelopeId: envelopeID,
                        recipientUserName: "Triston Gilbert",
                        recipientEmail: "triston.gilbert@dsxtr.com",
                        recipientClientUserId: "1",
                        animated: true,
                        completion: { _,_  in })
                }
            }
        }
    }
    
    func captiveSigningWithURL() {
        
        guard let token: String = Keychain.value(forKey: "token") else {
            return
        }
        
        webService.createEnvelope(accessToken: token) { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let envelopeID = data.envelopeId
                let signingUrl = self.webService.getSigningURL(for: envelopeID)
                DispatchQueue.main.async {
                    EnvelopesManager.shared.mDSMEnvelopesManager?.presentCaptiveSigning(
                        withPresenting: self,
                        signingUrl: signingUrl,
                        envelopeId: envelopeID,
                        recipientId: nil,
                        animated: true,
                        completion: { _,_  in })
                }
            }
        }
    }
    
    func cachedEnvelope() {
        EnvelopesManager.shared.mDSMEnvelopesManager?.presentComposeEnvelopeController(withPresenting: self, signingMode: .offline, resumeWithDraft: true, animated: true, completion: { _ in })
    }
}

extension UIEdgeInsets {
    var vertical: CGFloat { top + bottom }
    var horizontal: CGFloat { right + left }
}


