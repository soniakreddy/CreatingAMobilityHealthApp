/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main tab view controller used in the app.
*/

import UIKit
import HealthKit

/// The tab view controller for the app. The controller will load the last viewed view controller on `viewDidLoad`.
class MainTabViewController: UITabBarController {
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setUpTabViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setUpTabViewController() {
        let viewControllers = [
            createWelcomeViewController(),
            createWeeklyQuantitySampleTableViewController(),
            createChartViewController(),
            createWeeklyReportViewController()
        ]
        
        self.viewControllers = viewControllers.map {
            UINavigationController(rootViewController: $0)
        }
        
        delegate = self
        selectedIndex = getLastViewedViewControllerIndex()
        
        setUpTabBarAppearance(index: selectedIndex)
    }
    
    private func createWelcomeViewController() -> UIViewController {
        let viewController = WelcomeViewController()
        
        viewController.tabBarItem = UITabBarItem(title: Constants.homeTitle,
                                                 image: UIImage.image(from: Constants.home),
                                                 selectedImage: UIImage.image(from: Constants.homeFill))
        return viewController
    }
    
    private func createWeeklyQuantitySampleTableViewController() -> UIViewController {
        let dataTypeIdentifier = HKQuantityTypeIdentifier.walkingSpeed.rawValue
        let viewController = WeeklyQuantitySampleTableViewController(dataTypeIdentifier: dataTypeIdentifier)
        
        viewController.tabBarItem = UITabBarItem(title: Constants.healthDataTitle,
                                                 image: UIImage.image(from: Constants.healthData),
                                                 selectedImage: UIImage.image(from: Constants.healthDataFill))
        return viewController
    }
    
    private func createChartViewController() -> UIViewController {
        let viewController = MobilityChartDataViewController()
        
        viewController.tabBarItem = UITabBarItem(title: Constants.chartsTitle,
                                                 image: UIImage.image(from: Constants.charts),
                                                 selectedImage: UIImage.image(from: Constants.chartsFill))
        return viewController
    }
    
    private func createWeeklyReportViewController() -> UIViewController {
        let viewController = WeeklyReportTableViewController()
        
        viewController.tabBarItem = UITabBarItem(title: Constants.reportsTitle,
                                                 image: UIImage.image(from: Constants.reports),
                                                 selectedImage: UIImage.image(from: Constants.reportsFill))
        return viewController
    }
    
    // MARK: - View Persistence
    
    private static let lastViewControllerViewed = "LastViewControllerViewed"
    private var userDefaults = UserDefaults.standard
    
    private func getLastViewedViewControllerIndex() -> Int {
        if let index = userDefaults.object(forKey: Self.lastViewControllerViewed) as? Int {
            return index
        }
        
        return 0 // Default to first view controller.
    }
    
    func setUpTabBarAppearance(index: Int) {
        tabBar.tintColor = Constants.mossGreenColor
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        tabBar.unselectedItemTintColor = Constants.mossGreenColor
        tabBar.isTranslucent = false
        
        if index == 0 {
            tabBar.barTintColor = .white
        } else if index == 1 || index == 3 {
            tabBar.barTintColor = Constants.greenColor
        } else if index == 2 {
            tabBar.barTintColor = Constants.purpleColor
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        setLastViewedViewControllerIndex(index)
    }
    
    private func setLastViewedViewControllerIndex(_ index: Int) {
        userDefaults.set(index, forKey: Self.lastViewControllerViewed)
        setUpTabBarAppearance(index: index)
    }
}
