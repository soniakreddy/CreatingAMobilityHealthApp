/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table view controller that displays a chart and table view with health data samples.
*/

import UIKit
import HealthKit

class WeeklyReportTableViewController: HealthQueryTableViewController, ChartTableViewControllerDelegate, HealthQueryTableViewControllerDelegate {
    /// The date from the latest server response.
    private var dateLastUpdated: Date?
    private var currentChartType: ChartType = .weekly
    
    // MARK: Initializers
    
    init() {
        super.init(dataTypeIdentifier: HKQuantityTypeIdentifier.walkingSpeed.rawValue)
        
        // Set weekly predicate
        queryPredicate = createLastDateComponentPredicate(chartType: currentChartType)
        chartViewDelegate = self
        healthQueryDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Authorization
        if !dataValues.isEmpty { return }
        
        fetchData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        reloadData()
    }
    
    // MARK: - View Helper Functions
    
    private func fetchData() {
        queryPredicate = createLastDateComponentPredicate(chartType: currentChartType)
        HealthData.requestHealthDataAccessIfNeeded(dataTypes: [dataTypeIdentifier]) { (success) in
            if success {
                // Perform the query and reload the data.
                self.loadData(chartType: self.currentChartType)
            }
        }
    }
    
    private func reloadDataBasedOnOrientation(chartType: ChartType) {
        if chartType == .monthly || chartType == .quarterly {
            self.chartView.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers(chartType: UIDevice.current.orientation.isLandscape ? .monthly : .quarterly)
            currentChartType = UIDevice.current.orientation.isLandscape ? .monthly : .quarterly
        } else {
            self.chartView.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers(chartType: chartType)
            currentChartType = chartType
        }
        
        if let dateLastUpdated = self.dateLastUpdated {
            self.chartView.headerView.detailLabel.text = createChartDateLastUpdatedLabel(dateLastUpdated)
        }
    }
    
    // MARK: - Selector Overrides
    
    @objc
    override func didTapFetchButton() {
        Network.pull() { [weak self] (serverResponse) in
            guard let self = self else { return }
            self.dateLastUpdated = serverResponse.date
            self.queryPredicate = createLastDateComponentPredicate(from: serverResponse.date, chartType: self.currentChartType)
            self.handleServerResponse(serverResponse)
        }
    }
    
    func didSelectChartTypeAction(dataTypeIdentifier: String) {
        HealthData.requestHealthDataAccessIfNeeded(dataTypes: [dataTypeIdentifier]) { (success) in
            if success {
                // Perform the query and reload the data.
                self.loadData(chartType: self.currentChartType)
            }
        }
    }
    
    func didSelectChartType(_ chartType: ChartType) {
        currentChartType = chartType
        fetchData()
        reloadDataBasedOnOrientation(chartType: currentChartType)
    }
    
    // MARK: - Network
    
    /// Handle a response fetched from a remote server. This function will also save any HealthKit samples and update the UI accordingly.
    override func handleServerResponse(_ serverResponse: ServerResponse) {
        let weeklyReport = serverResponse.weeklyReport
        let addedSamples = weeklyReport.samples.map { (serverHealthSample) -> HKQuantitySample in
                        
            // Set the sync identifier and version
            var metadata = [String: Any]()
            let sampleSyncIdentifier = String(format: "%@_%@", weeklyReport.identifier, serverHealthSample.syncIdentifier)
            
            metadata[HKMetadataKeySyncIdentifier] = sampleSyncIdentifier
            metadata[HKMetadataKeySyncVersion] = serverHealthSample.syncVersion
            
            // Create HKQuantitySample
            let quantity = HKQuantity(unit: .meter(), doubleValue: serverHealthSample.value)
            let sampleType = HKQuantityType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)!
            let quantitySample = HKQuantitySample(type: sampleType,
                                                  quantity: quantity,
                                                  start: serverHealthSample.startDate,
                                                  end: serverHealthSample.endDate,
                                                  metadata: metadata)
            
            return quantitySample
        }
        
        HealthData.healthStore.save(addedSamples) { (success, error) in
            if success {
                self.loadData(chartType: self.currentChartType)
            }
        }
    }
    
    // MARK: Function Overrides
    
    override func reloadData() {
        super.reloadData()
        
        // Change axis to use weekdays for six-minute walk sample
        DispatchQueue.main.async {
            self.reloadDataBasedOnOrientation(chartType: self.currentChartType)
        }
    }
}
