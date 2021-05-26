//
//  String+Extension.swift
//  SmoothWalker
//
//  Created by sokolli on 5/26/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func stringToDate(dateString: String, chartType: ChartType) -> Date {
        let dateFormatter = DateFormatter()
        switch chartType {
        case .daily: dateFormatter.dateFormat = "HH"
        case .weekly: dateFormatter.dateFormat = "EEE"
        case .monthly: dateFormatter.dateFormat = "MMM"
        case .quarterly: dateFormatter.dateFormat = "Q"
            if let string = Constants.quarters.firstIndex(of: dateString) {
                return dateFormatter.date(from: String(string + 1)) ?? Constants.today
            }
        }
        return dateFormatter.date(from: dateString) ?? Constants.today
    }
}
