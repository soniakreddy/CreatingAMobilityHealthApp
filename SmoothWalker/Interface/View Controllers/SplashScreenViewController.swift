/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view controller with a simple message and action button.
*/

import UIKit

protocol SplashScreenViewControllerDelegate: SplashScreenViewController {
    func didSelectActionButton()
}

class SplashScreenViewController: UIViewController {
    private var duration: TimeInterval!
    weak var splashScreenDelegate: SplashScreenViewControllerDelegate?
    
    var walkingSpeedText: String = "" {
        didSet {
            guard walkingSpeedText != oldValue else { return }
            walkingSpeedContainerView.walkingSpeedText = walkingSpeedText
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = .border
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = .cornerRadius
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.isHidden = false
        
        return view
    }()
    
    private lazy var walkingSpeedContainerView: WalkingSpeedContainerView = {
        let view = WalkingSpeedContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private lazy var dashboardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dashboardImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: Constants.homeIllustration)
        
        return view
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Constants.purpleDarkColor
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: .boldFontSize, weight: .bold)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(Constants.purpleDarkColor, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .regularFontSize, weight: .regular)
        label.textColor = Constants.mossGreenColor
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    // MARK: Initalizers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    // MARK: - View Helper Functions
    
    private func setUpViews() {
        view.addSubview(containerView)
        view.addSubview(dashboardView)
        view.addSubview(walkingSpeedContainerView)
        view.addSubview(spinnerView)
        
        dashboardView.addSubview(dashboardImageView)
        containerView.addSubview(actionButton)
        containerView.addSubview(descriptionLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += createDashboardViewConstraints()
        constraints += createWalkingSpeedContainerViewConstraints()
        constraints += createSpinnerViewConstraints()
        constraints += createContainerViewConstraints()
        constraints += createActionButtonConstraints()
        constraints += createDescriptionLabelConstraints()
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func createDashboardViewConstraints() -> [NSLayoutConstraint] {
        let leading = dashboardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .inset)
        let trailing = dashboardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.inset)
        let top =  NSLayoutConstraint(item: dashboardView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: .multiplier, constant: 0)
        let centerX = dashboardImageView.centerXAnchor.constraint(equalTo: dashboardView.centerXAnchor)
        let centerY = dashboardImageView.centerYAnchor.constraint(equalTo: dashboardView.centerYAnchor)
        let dashboardHeight = dashboardView.heightAnchor.constraint(equalTo: dashboardImageView.heightAnchor)
        
        return [leading, trailing, top, centerX, centerY, dashboardHeight]
    }
    
    private func createWalkingSpeedContainerViewConstraints() -> [NSLayoutConstraint] {
        let leading = walkingSpeedContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .inset)
        let trailing = walkingSpeedContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.inset)
        let bottom = NSLayoutConstraint(item: walkingSpeedContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: .multiplier, constant: 0)
        
        return [leading, trailing, bottom]
    }
    
    private func createSpinnerViewConstraints() -> [NSLayoutConstraint] {
        let centerX = spinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        let centerY = spinnerView.centerYAnchor.constraint(equalTo: dashboardView.bottomAnchor, constant: .inset)
        
        return [centerX, centerY]
    }
    
    private func createContainerViewConstraints() -> [NSLayoutConstraint] {
        let leading = containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .inset)
        let trailing = containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.inset)
        let top = containerView.topAnchor.constraint(equalTo: walkingSpeedContainerView.topAnchor)
        let bottom = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: .multiplier, constant: 0)
        
        return [leading, trailing, top, bottom]
    }
    
    private func createActionButtonConstraints() -> [NSLayoutConstraint] {
        let top = actionButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding)
        let centerX = actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        return [top, centerX]
    }
    
    private func createDescriptionLabelConstraints() -> [NSLayoutConstraint] {
        let top = descriptionLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .padding)
        let bottom = descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.inset)
        let leading = descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .padding)
        let trailing = descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.padding)
        
        return [top, bottom, leading, trailing]
    }
    
    // MARK: - Public functions
    
    func updateViews(_ permissionsAuthorized: Bool) {
        containerView.isHidden = permissionsAuthorized
        walkingSpeedContainerView.isHidden = !permissionsAuthorized
    }
    
    func startAnimation() {
        spinnerView.startAnimating()
    }
    
    func stopAnimation() {
        spinnerView.stopAnimating()
    }
    
    // MARK: - Selectors
    
    @objc
    private func didTapActionButton() {
        splashScreenDelegate?.didSelectActionButton()
    }
}
