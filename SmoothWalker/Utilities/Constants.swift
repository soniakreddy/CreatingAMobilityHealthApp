//
//  Constants.swift
//  SmoothWalker
//
//  Created by sokolli on 5/26/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    //Scaling
    static let height: CGFloat = 125.0
    static let cornerRadius: CGFloat = 15.0
    static let multiplier: CGFloat = 0.9
    static let minimumScaleFactor: CGFloat = 0.2
    static let zero: CGFloat = 0.0
    static let border: CGFloat = 1.0
    
    //Padding
    static let itemSpacing: CGFloat = 12.0
    static let itemSpacingWithTitle: CGFloat = 0.0
    static let inset: CGFloat = 20.0
    static let horizontalInset: CGFloat = 40.0
    static let textPadding: CGFloat = 5.0
    static let padding: CGFloat = 15.0
    
    //Fonts
    static let regularFontSize: CGFloat = 16.0
    static let boldFontSize: CGFloat = 20.0
    static let heavyFontSize: CGFloat = 55.0
}

struct Constants {
    
    // Purple Colors
    static let purpleColor = UIColor(red: 234/255, green: 225/255, blue: 255/255, alpha: 1.0)
    static let purpleLightColor = UIColor(red: 139/255, green: 164/255, blue: 249/255, alpha: 1.0)
    static let purpleDarkColor = UIColor(red: 188/255, green: 156/255, blue: 255/255, alpha: 1.0)
    
    // Blue Color
    static let blueColor = UIColor(red: 102/255, green: 210/255, blue: 234/255, alpha: 1.0)
    
    // Green Colors
    static let greenColor = UIColor(red: 213/255, green: 244/255, blue: 228/255, alpha: 1.0)
    static let greenDarkColor = UIColor(red: 111/255, green: 207/255, blue: 151/255, alpha: 1.0)
    static let tealColor = UIColor(red: 125/255, green: 189/255, blue: 164/255, alpha: 1.0)
    static let mossGreenColor = UIColor(red: 28/255, green: 48/255, blue: 52/255, alpha: 1.0)
    static let mintGreenColor = UIColor(red: 0/255, green: 146/255, blue: 107/255, alpha: 1.0)
    
    // Date
    static let today = Date()
    
    // Strings
    static let cancel = "Cancel"
    static let add = "Add"
    static let dismiss = "Dismiss"
    static let homeTitle = "Dashboard"
    static let healthDataTitle = "Health Data"
    static let chartsTitle = "Charts"
    static let reportsTitle = "Reports"
    
    // Axis Strings
    static let hours = ["00", "02", "04", "06", "08", "10", "12", "14", "16", "18", "20", "22"]
    static let daysFull = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    static let daysShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    static let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    static let quarters = ["Jan-Mar", "Apr-Jun", "Jul-Sep", "Oct-Dec"]
    
    // Chart Type Strings
    static let daily = "Daily"
    static let weekly = "Weekly"
    static let monthly = "Monthly"
    static let quarterly = "Quarterly"
    
    // Image Name Strings
    static let home = "home"
    static let homeFill = "home-fill"
    static let healthData = "heartbeat"
    static let healthDataFill = "heartbeat-fill"
    static let charts = "chart-bar"
    static let chartsFill = "chart-bar-fill"
    static let reports = "clipboard-text"
    static let reportsFill = "clipboard-text-fill"
    static let menu = "dots-three-outline-vertical-fill"
    static let addMore = "plus-fill"
    static let getData = "arrow-line-down-fill"
    static let homeIllustration = "healthy_lifestyle"
    static let emptyDataIllustration = "leaves"
    
    // Attribute Keys
    static let attributeTitleKey = "attributedTitle"
    static let titleKey = "titleTextColor"
}
