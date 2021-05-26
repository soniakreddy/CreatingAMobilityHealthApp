//
//  WalkingSpeedContainerView.swift
//  SmoothWalker
//
//  Created by sokolli on 5/26/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

class WalkingSpeedContainerView: UIView {
    var walkingSpeedText: String = ""{
        didSet {
            guard walkingSpeedText != oldValue else { return }
            walkingSpeedLabel.text = walkingSpeedText
        }
    }
    
    private lazy var walkingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = .border
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = .cornerRadius
        view.isHidden = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Walking \nSpeed"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .regularFontSize, weight: .bold)
        label.textColor = Constants.purpleDarkColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .minimumScaleFactor
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var unitsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "m/s"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .regularFontSize, weight: .regular)
        label.textColor = Constants.mossGreenColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .minimumScaleFactor
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var walkingSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .minimumScaleFactor
        label.font = .systemFont(ofSize: .heavyFontSize, weight: .heavy)
        label.textColor = Constants.mossGreenColor
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var walkingSpeedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(walkingContainerView)
        walkingContainerView.addSubview(walkingSpeedView)
        walkingContainerView.addSubview(titleLabel)
        walkingSpeedView.addSubview(walkingSpeedLabel)
        walkingSpeedView.addSubview(unitsTextLabel)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Helper Functions
    
    private func setUpConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += createWalkingContainerViewConstraints()
        constraints += createTitleLabelConstraints()
        constraints += createWalkingSpeedViewConstraints()
        constraints += createUnitsTextLabelConstraints()
        constraints += createUnitsTextLabelConstraints()
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func createWalkingContainerViewConstraints() -> [NSLayoutConstraint] {
        let leading = walkingContainerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = walkingContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let top = walkingContainerView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = walkingContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let height = walkingContainerView.heightAnchor.constraint(equalToConstant: .height)
        
        return [leading, trailing, top, bottom, height]
    }
    
    private func createTitleLabelConstraints() -> [NSLayoutConstraint] {
        let centerY = titleLabel.centerYAnchor.constraint(equalTo: walkingContainerView.centerYAnchor)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: walkingContainerView.leadingAnchor, constant: .inset)
        
        return [centerY, leading]
    }
    
    private func createWalkingSpeedViewConstraints() -> [NSLayoutConstraint] {
        let leading = walkingSpeedView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .inset)
        let trailing = walkingSpeedView.trailingAnchor.constraint(equalTo: walkingContainerView.trailingAnchor, constant: -.inset)
        let top = walkingSpeedView.topAnchor.constraint(equalTo: walkingContainerView.topAnchor, constant: .inset)
        let bottom = walkingSpeedView.bottomAnchor.constraint(equalTo: walkingContainerView.bottomAnchor, constant: -.inset)
        
        let labelTrailing = walkingSpeedView.trailingAnchor.constraint(equalTo: walkingSpeedLabel.trailingAnchor, constant: .inset)
        let centerY = walkingSpeedView.centerYAnchor.constraint(equalTo: walkingContainerView.centerYAnchor)
        
        return [leading, trailing, top, bottom, labelTrailing, centerY]
    }
    
    private func createUnitsTextLabelConstraints() -> [NSLayoutConstraint] {
        let top = unitsTextLabel.topAnchor.constraint(equalTo: walkingSpeedLabel.bottomAnchor, constant: .textPadding)
        let centerX = unitsTextLabel.centerXAnchor.constraint(equalTo: walkingSpeedLabel.centerXAnchor)
        
        return [top, centerX]
    }
}
