
import Foundation
import UIKit

class EmptyDataLabel: UILabel {
    
    weak var sourceView: UIView?
    
    convenience init(sourceView: UIView) {
        self.init()
        self.sourceView = sourceView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
        text = "No available data"
        textAlignment = .center
        textColor = .gray
        font = UIFont(name: "Helvetica Neue", size: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard var view = superview else {
            return
        }
                
        if let sourceView = sourceView {
            view = sourceView
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}

