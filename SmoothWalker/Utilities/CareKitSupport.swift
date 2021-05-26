/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A collection of utility functions used for charting and visualizations.
*/

import Foundation
import CareKitUI

enum ChartType: CaseIterable {
    case daily
    case weekly
    case monthly
    case quarterly
    
    var rawValue: String {
        switch self {
        case .daily: return Constants.daily
        case .weekly: return Constants.weekly
        case .monthly: return Constants.monthly
        case .quarterly: return Constants.quarterly
        }
    }
}

// MARK: - Chart Date UI

/// Return a label describing the date range of the chart for the last week. Example: "Jun 3 - Jun 10, 2020"
func createChartWeeklyDateRangeLabel(lastDate: Date = Date()) -> String {
    let calendar: Calendar = .current
    
    let endOfWeekDate = lastDate
    let startOfWeekDate = getStartDate(from: endOfWeekDate)
    
    let monthDayDateFormatter = DateFormatter()
    monthDayDateFormatter.dateFormat = "MMM d"
    let monthDayYearDateFormatter = DateFormatter()
    monthDayYearDateFormatter.dateFormat = "MMM d, yyyy"
    
    var startDateString = monthDayDateFormatter.string(from: startOfWeekDate)
    var endDateString = monthDayYearDateFormatter.string(from: endOfWeekDate)
    
    // If the start and end dates are in the same month.
    if calendar.isDate(startOfWeekDate, equalTo: endOfWeekDate, toGranularity: .month) {
        let dayYearDateFormatter = DateFormatter()
        
        dayYearDateFormatter.dateFormat = "d, yyyy"
        endDateString = dayYearDateFormatter.string(from: endOfWeekDate)
    }
    
    // If the start and end dates are in different years.
    if !calendar.isDate(startOfWeekDate, equalTo: endOfWeekDate, toGranularity: .year) {
        startDateString = monthDayYearDateFormatter.string(from: startOfWeekDate)
    }
    
    return String(format: "%@–%@", startDateString, endDateString)
}

private func createMonthDayDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MM/dd"
    
    return dateFormatter
}

func createChartDateLastUpdatedLabel(_ dateLastUpdated: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateStyle = .medium
    
    return "last updated on \(dateFormatter.string(from: dateLastUpdated))"
}

/// Returns an array of horizontal axis markers based on the desired time frame, where the last axis marker corresponds to `lastDate`
/// `useWeekdays` will use short day abbreviations (e.g. "Sun, "Mon", "Tue") instead.
/// Defaults to showing the current day as the last axis label of the chart and going back one week.

private func titles(for chartType: ChartType) -> [String] {
    switch chartType {
    case .daily:
        return Constants.hours
    case .weekly:
        return Constants.daysShort
    case .monthly:
        return Constants.months
    case .quarterly:
        return Constants.quarters
    }
}

func createHorizontalAxisMarkers(chartType: ChartType = .weekly, lastDate: Date = Date()) -> [String] {
    let calendar: Calendar = .current
    let titles = titles(for: chartType)
    
    switch chartType {
    case .daily:
        let hour = calendar.component(.hour, from: lastDate)
        var indexOfHour = 0
        if titles.contains("\(hour)")  {
            indexOfHour = titles.firstIndex(of: "\(hour)")!
        } else if  titles.contains("\(hour + 1)") {
            indexOfHour = titles.firstIndex(of: "\(hour + 1)")!
        }
        return Array(titles[indexOfHour..<titles.count]) + Array(titles[0..<indexOfHour])
    case .weekly:
        let weekday = calendar.component(.weekday, from: lastDate)
        return Array(titles[weekday..<titles.count]) + Array(titles[0..<weekday])
    case .monthly:
        let month = calendar.component(.month, from: lastDate)
        return Array(titles[month..<titles.count]) + Array(titles[0..<month])
    case .quarterly:
        let quarter = calendar.component(.quarter, from: lastDate) + 1
        return Array(titles[quarter..<titles.count]) + Array(titles[0..<quarter])
    }
}

func createHorizontalAxisMarkers(for dates: [Date]) -> [String] {
    let dateFormatter = createMonthDayDateFormatter()
    
    return dates.map { dateFormatter.string(from: $0) }
}
