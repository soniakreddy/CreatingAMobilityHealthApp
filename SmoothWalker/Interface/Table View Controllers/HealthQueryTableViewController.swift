/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A table view controller that displays health data with a chart header view with refresh capabilities.
*/

import UIKit
import HealthKit
import CareKitUI

protocol HealthQueryTableViewControllerDelegate: HealthQueryTableViewController {
    func didSelectChartTypeAction(dataTypeIdentifier: String)
}

class HealthQueryTableViewController: ChartTableViewController, HealthQueryDataSource {
    
    weak var healthQueryDelegate: HealthQueryTableViewControllerDelegate?
    var queryPredicate: NSPredicate? = nil
    var queryAnchor: HKQueryAnchor? = nil
    var queryLimit: Int = HKObjectQueryNoLimit
    
    // MARK: - View Life Cycle Overrides
    
    override func setUpViewController() {
        super.setUpViewController()
        
        setUpFetchButton()
        setUpRefreshControl()
    }
    
    // MARK: - View Helper Functions
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        
        self.refreshControl = refreshControl
    }
    
    private func setUpFetchButton() {
        let rightBarButtonItem = UIBarButtonItem(image:  UIImage.image(from: Constants.getData), style: .plain, target: self, action: #selector(didTapFetchButton))
        rightBarButtonItem.tintColor = Constants.mossGreenColor
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage.image(from: Constants.menu), style: .plain, target: self, action: #selector(didTapMoreButton))
        leftBarButtonItem.tintColor = Constants.mossGreenColor
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    // MARK: - Selectors
    
    @objc
    func didTapFetchButton() {
        fetchNetworkData()
    }
    
    @objc
    private func didTapMoreButton() {
        let title = "Select Health Data Type"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for dataType in HealthData.readDataTypes {
            if dataType.identifier == HKQuantityTypeIdentifier.sixMinuteWalkTestDistance.rawValue || dataType.identifier == HKQuantityTypeIdentifier.walkingSpeed.rawValue {
                let actionTitle = getDataTypeName(for: dataType.identifier)
                let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] (action) in
                    self?.didSelectDataTypeIdentifier(dataType.identifier)
                }
                action.setValue(UIColor.label, forKey: Constants.titleKey)
                
                alertController.addAction(action)
            }
        }
        
        let cancel = UIAlertAction(title: Constants.cancel, style: .cancel)
        cancel.setValue(Constants.mintGreenColor, forKey: Constants.titleKey)
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    private func didSelectDataTypeIdentifier(_ dataTypeIdentifier: String) {
        self.dataTypeIdentifier = dataTypeIdentifier
        healthQueryDelegate?.didSelectChartTypeAction(dataTypeIdentifier: dataTypeIdentifier)
    }
    
    @objc
    private func refreshControlValueChanged() {
        loadData(chartType: .weekly)
    }
    
    // MARK: - Network
    
    func fetchNetworkData() {
        Network.pull() { [weak self] (serverResponse) in
            self?.handleServerResponse(serverResponse)
        }
    }
    
    /// Process a response sent from a remote server.
    func handleServerResponse(_ serverResponse: ServerResponse) {
        loadData(chartType: .weekly)
    }
    
    // MARK: - HealthQueryDataSource
    
    /// Perform a query and reload the data upon completion.
    func loadData(chartType: ChartType) {
        performQuery(chartType: chartType) {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    func performQuery(chartType: ChartType, completion: @escaping () -> Void) {
        guard let sampleType = getSampleType(for: dataTypeIdentifier) else { return }
        
        let anchoredObjectQuery = HKAnchoredObjectQuery(type: sampleType,
                                                        predicate: queryPredicate,
                                                        anchor: queryAnchor,
                                                        limit: queryLimit) {
            (query, samplesOrNil, deletedObjectsOrNil, anchor, errorOrNil) in
            
            guard let samples = samplesOrNil else { return }
            
            self.dataValues = samples.map { (sample) -> HealthDataTypeValue in
                var dataValue = HealthDataTypeValue(startDate: sample.startDate,
                                                    endDate: sample.endDate,
                                                    value: .zero)
                if let quantitySample = sample as? HKQuantitySample,
                   let unit = preferredUnit(for: quantitySample) {
                    dataValue.value = quantitySample.quantity.doubleValue(for: unit)
                }
                
                return dataValue
            }
            self.averageDataValues = self.groupSampleByDate(chartType: chartType)
            completion()
        }
        
        HealthData.healthStore.execute(anchoredObjectQuery)
    }
    
    // Groups samples by date
    private func groupSampleByDate(chartType: ChartType) -> [HealthDataTypeValue] {
        var result: [Date: [Double]] = [:]
        
        let samples = dataValues.map({ sample -> [String: Any] in
            switch chartType {
            case .daily:
                return ["Date": Calendar.current.date(from: Calendar.current.dateComponents([.hour], from: sample.startDate)) ?? Constants.today,
                        "Value": sample.value]
            case .weekly:
                return ["Date": Calendar.current.date(from: Calendar.current.dateComponents([.day], from: sample.startDate)) ?? Constants.today,
                        "Value": sample.value]
            case .monthly, .quarterly:
                return ["Date": Calendar.current.date(from: Calendar.current.dateComponents([.month], from: sample.startDate)) ?? Constants.today,
                        "Value": sample.value]
            }
        })
        
        for sample in samples {
            let date = sample["Date"] as! Date
            let value = sample["Value"] as! Double
            
            if result.keys.contains(date) {
                var valueForKey = result[date]!
                valueForKey.append(value)
                result[date] = valueForKey
            } else {
                result[date] = [value]
            }
        }
        
        var data: [HealthDataTypeValue] = []
        
        for (startDate, values) in result {
            data.append(HealthDataTypeValue(startDate: startDate, endDate: Date(), value: getAverageByDate(values: values)))
        }
        return sort(data, for: chartType)
    }
    
    // Sorts data by date and inserts empty data when data is not present for a date, this is to fill the chart for all chart type axis markers
    private func sort(_ healthData: [HealthDataTypeValue], for chartType: ChartType) -> [HealthDataTypeValue] {
        var data: [HealthDataTypeValue] = healthData
        var days: [String] = []
        switch chartType {
        case .daily:
            days = healthData.sorted(by: {$0.startDate < $1.startDate}).map({ sample -> String in
                guard let hour = sample.startDate.componentsForDate(.hour).hour else { return "" }
                if hour % 2 == 0 {
                    return String(hour)
                } else {
                    return String(hour + 1)
                }
            })
        case .weekly:
            days = healthData.sorted(by: {$0.startDate < $1.startDate}).map({String($0.startDate.day.prefix(3))})
        case .monthly:
            days = healthData.sorted(by: {$0.startDate < $1.startDate}).map({String($0.startDate.month.prefix(3))})
        case .quarterly:
            let quarterlyDictionary = [0: ["Jan", "Feb", "Mar"], 1: ["Apr", "May", "Jun"], 2: ["Jul", "Aug", "Sep"], 3: ["Oct", "Nov", "Dec"]]
            let months = healthData.sorted(by: {$0.startDate < $1.startDate}).map({String($0.startDate.month.prefix(3))})
            var quarters: [String] = []
            for month in months {
                for key in quarterlyDictionary.keys {
                    if let quarterlyMonths = quarterlyDictionary[key], quarterlyMonths.contains(month) {
                        quarters.append(Constants.quarters[key])
                    }
                }
            }
            days = quarters
        }
        let axisMarkers = createHorizontalAxisMarkers(chartType: chartType, lastDate: Constants.today)
        for day in axisMarkers {
            let index = axisMarkers.firstIndex(of: day)
            if !days.contains(day) {
                data.insert(HealthDataTypeValue(startDate: day.stringToDate(dateString: day, chartType: chartType), endDate: Constants.today, value: 0.0), at: index!)
            }
        }
        return data
    }
    
    private func getAverageByDate(values: [Double]) -> Double {
        var sum = 0.0
        for value in values {
            sum += value
        }
        return sum/Double(values.count)
    }
    
    /// Override `reloadData` to update `chartView` before reloading `tableView` data.
    override func reloadData() {
        DispatchQueue.main.async {
            self.chartView.applyDefaultConfiguration()
            
            let dateLastUpdated = Date()
            self.chartView.headerView.detailLabel.text = createChartDateLastUpdatedLabel(dateLastUpdated)
            self.chartView.headerView.titleLabel.text = getDataTypeName(for: self.dataTypeIdentifier)
            
            let sampleStartDates = self.averageDataValues.map { $0.startDate }
            
            self.chartView.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers(for: sampleStartDates)
            
            let dataSeries = self.averageDataValues.map{ CGFloat($0.value) }
            
            guard
                let unit = preferredUnit(for: self.dataTypeIdentifier),
                let unitTitle = getUnitDescription(for: unit)
            else {
                return
            }
            
            let series = OCKDataSeries(values: dataSeries, title: unitTitle, gradientStartColor: Constants.greenDarkColor, gradientEndColor: Constants.blueColor)
            
            self.chartView.graphView.dataSeries = [
                series
            ]
            
            self.view.layoutIfNeeded()
            
            super.reloadData()
        }
    }
}
