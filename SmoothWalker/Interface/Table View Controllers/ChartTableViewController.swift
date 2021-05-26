/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table view controller that displays health data with a chart header view.
*/

import UIKit
import CareKitUI
import HealthKit

protocol ChartTableViewControllerDelegate: ChartTableViewController {
    func didSelectChartType(_ chartType: ChartType)
}

/// A `DataTableViewController` with a chart header view.
class ChartTableViewController: DataTableViewController {
    
    weak var chartViewDelegate: ChartTableViewControllerDelegate?
    
    // MARK: - UI Properties
    
    private var titles = [ChartType.daily.rawValue, ChartType.weekly.rawValue, ChartType.monthly.rawValue]
    
    lazy var headerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [ChartType.daily.rawValue, ChartType.weekly.rawValue, ChartType.monthly.rawValue])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.accessibilityIdentifier = "segmentedControl"
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.clipsToBounds = true
        segmentedControl.backgroundColor = .clear
        segmentedControl.selectedSegmentTintColor = Constants.tealColor
        segmentedControl.layer.masksToBounds = true
        segmentedControl.setTitleTextAttributes([.foregroundColor: Constants.mossGreenColor, .font: UIFont.systemFont(ofSize: .regularFontSize, weight: .regular)], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Constants.mossGreenColor, .font: UIFont.systemFont(ofSize: .regularFontSize, weight: .semibold)], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var chartView: OCKCartesianChartView = {
        let chartView = OCKCartesianChartView(type: .bar)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.applyHeaderStyle()
        
        return chartView
    }()
    
    @objc private func segmentedControlDidChange(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            chartViewDelegate?.didSelectChartType(.daily)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            chartViewDelegate?.didSelectChartType(.weekly)
        } else if segmentedControl.selectedSegmentIndex == 2 {
            chartViewDelegate?.didSelectChartType(UIDevice.current.orientation.isLandscape ? .monthly : .quarterly)
        }
        
    }
    
    // MARK: - View Life Cycle Overrides
    
    override func viewDidLayoutSubviews() {
        segmentedControl.layer.cornerRadius = segmentedControl.bounds.height / 2
    }
    
    override func updateViewConstraints() {
        chartViewBottomConstraint?.constant = showGroupedTableViewTitle ? .itemSpacingWithTitle : .itemSpacing
        
        super.updateViewConstraints()
    }
    
    override func setUpViewController() {
        super.setUpViewController()
        
        setUpHeaderView()
        setUpConstraints()    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
        showGroupedTableViewTitle = true
    }
    
    private func setUpHeaderView() {
        headerView.addSubview(segmentedControl)
        headerView.addSubview(chartView)
        tableView.tableHeaderView = headerView
    }

    private func setUpConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints += createHeaderViewConstraints()
        constraints += createSegmentedControlConstraints()
        constraints += createChartViewConstraints()
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func createHeaderViewConstraints() -> [NSLayoutConstraint] {
        let leading = headerView.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor, constant: .inset)
        let trailing = headerView.trailingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.trailingAnchor, constant: -.inset)
        let top = headerView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: .itemSpacing)
        let centerX = headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        
        return [leading, trailing, top, centerX]
    }
    
    private func createSegmentedControlConstraints() -> [NSLayoutConstraint] {
        let leading = segmentedControl.leadingAnchor.constraint(equalTo: chartView.leadingAnchor)
        let trailing = segmentedControl.trailingAnchor.constraint(equalTo: chartView.trailingAnchor)
        let top = segmentedControl.topAnchor.constraint(equalTo: headerView.topAnchor)
        let bottom = segmentedControl.bottomAnchor.constraint(equalTo: chartView.topAnchor, constant: -.itemSpacing)
        
        return [leading, trailing, top, bottom]
        
    }
    
    private var chartViewBottomConstraint: NSLayoutConstraint?
    private func createChartViewConstraints() -> [NSLayoutConstraint] {
        let leading = chartView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor)
        let trailing = chartView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        let bottomConstant: CGFloat = showGroupedTableViewTitle ? .itemSpacingWithTitle : .itemSpacing
        let bottom = chartView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -bottomConstant)
        
        chartViewBottomConstraint = bottom
        
        trailing.priority -= 1
        bottom.priority -= 1

        return [leading, trailing, bottom]
    }
}
