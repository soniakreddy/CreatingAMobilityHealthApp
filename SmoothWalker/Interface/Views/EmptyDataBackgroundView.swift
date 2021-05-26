/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view used for the background of table views when there is no data.
*/

import UIKit

/// A view with a centered label to communicate there is no data available.
class EmptyDataBackgroundView: UIView {
    
    init(displayImage: Bool) {
        imageView.isHidden = displayImage
        
        super.init(frame: .zero)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        addSubview(imageView)
        
        addConstraints()
    }
    
    var imageView: UIImageView =  {
        let imageView = UIImageView(image: UIImage(named: Constants.emptyDataIllustration))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    func addConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += addLabelConstraints()
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func addLabelConstraints() -> [NSLayoutConstraint] {
        return [
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.horizontalInset),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
    }
}
