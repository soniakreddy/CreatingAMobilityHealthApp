# Extending the Mobility Health App

The base health app  allows a clinical care team to send and receive mobility data, extending it to support walking speed average.

## Overview

- Note: This sample code project is associated with WWDC20 session [10664: Getting Started in HealthKit](https://developer.apple.com/wwdc20/10664/) and WWDC20 session [10184: Synchronizing Your Health Data with HealthKit](https://developer.apple.com/wwdc20/10184/).

- The extended code consists of some new image assets, updated splash screen & a new color palette.
The reports chart functionality now displays for daily, weekly & monthly.

- For monthly, the chart displays with the horizontal axis distributed over quarterly timelines & upon landscape device orientation change it displays monthly timelines.

- Few small fixes for current sample code include refreshing view upon new data entered in Health Data tab.

- Code is tested on real data on iPhone 12 pro (Demo video included with this project for reference purpose) and code was also tested with mock data on iPhone 12 simulator.

- App supports both light and dark color themes (Pictures included with this project for reference purpose)

## Configure the Sample Code Project

Before you run the sample code project in Xcode:

* Download the latest version of Xcode with the iOS 14 SDK. The sample code project requires this version of Xcode.
* Confirm that CareKit is included as a dependency in Swift Packages.
* Upon running it on device authorize the application by going to "Settings" -> "General" -> "Device Management" -> Trust the "Apple Development: ..."
