//
//  Date+Extension.swift
//  SmoothWalker
//
//  Created by sokolli on 5/26/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

extension Date {
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    public var day: String {
        return Date.dayFormatter.string(from: self)
    }
    
    public var month: String {
        return Date.monthFormatter.string(from: self)
    }
    
    public func componentsForDate(_ dateComponent: Calendar.Component) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([dateComponent], from: self)
    }
    
}
