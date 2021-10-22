
import Foundation
import UIKit

class VCFactory {
    
    static func createSettingsVC() -> UIViewController {
         let settingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        
         return settingsVC
    }
    
    static func createHomeVC() -> UIViewController {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeVC")
        
        return homeVC
    }
    
    static func createAgreementVC(with clientFile: ClientModel) -> UIViewController {
        let agreementStoryboard = UIStoryboard(name: "AgreementVC", bundle: nil)
        let agreementVC = agreementStoryboard.instantiateViewController(identifier: "AgreementVC") as AgreementVC
        agreementVC.clientFile = clientFile
        
        return agreementVC
    }
    
    static func createPortfolioVC(with clientFile: ClientModel) -> UIViewController {
        let agreementStoryboard = UIStoryboard(name: "AgreementVC", bundle: nil)
        let portfolioVC = agreementStoryboard.instantiateViewController(identifier: "PortfolioVC") as PortfolioVC
        
        return portfolioVC
    }
    
    static func createContactVC(with clientFile: ClientModel) -> UIViewController {
        let agreementStoryboard = UIStoryboard(name: "AgreementVC", bundle: nil)
        let contactVC = agreementStoryboard.instantiateViewController(identifier: "ContactVC") as ContactVC
        
        return contactVC
    }
    
    static func createViewAgreementVC(with clientFile: ClientModel) -> UIViewController {
        
        let viewAgreementVC = ViewAgreementVC(nibName: "ViewAgreementVC", bundle: nil) as ViewAgreementVC
        viewAgreementVC.client = clientFile
        
        return viewAgreementVC
    }
    
}
