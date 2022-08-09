//
//  WindData.swift
//  Wind
//
//  Created by Carlyn Maw on 6/20/22.
//

import Foundation
//import BlueSky


class WeatherMapping:ObservableObject {
    var weatherSource = WeatherDataService.shared
    
    @Published var windDirectionFactor = 0.0
    @Published var windSpeedFactor = 0.1
    @Published var gustSpeedFactor = 0.1
    
    private var windDirectionRadians = 0.0
    private var windSpeedMPS = 0.0
    private var windGustSpeed:Double? = nil
    @Published private(set) var weatherDate:Date = Date.now
    
    var weatherAge:TimeInterval {
        Date.timeIntervalSinceReferenceDate - weatherDate.timeIntervalSinceReferenceDate
    }

    func updateWeather() async {
        await weatherSource.updateCachedWeather()
        updateInteralWindData()
        calculateFactors()
    }
    
    func updateInteralWindData() {
        if let windReport = weatherSource.windReport {
            windDirectionRadians = windReport.directionAsRadians
            windSpeedMPS = windReport.speedAsMPS
            windGustSpeed = windReport.gustSpeedAsMPS
            weatherDate = windReport.date
        } else {
            print("No wind report")
        }
    }
    
    func calculateFactors() {
        windDirectionFactor = windDirectionRadians
        windSpeedFactor = windSpeedMPS / 1000
        gustSpeedFactor = (windGustSpeed ?? 0) / 1000
    }
}

extension WeatherMapping {
    static var example:WeatherMapping {
        WeatherMapping()
    }
}
