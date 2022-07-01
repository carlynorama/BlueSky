//
//  File.swift
//  
//
//  Created by Labtanza on 7/1/22.
//

import Foundation
import WeatherKit

#if DEBUG
// Use this for preview data.


extension WindReport {
    static var example:WindReport {
        WindReport(
            date: Date.now,
            direction: Measurement<UnitAngle>(value: 23, unit: .degrees),
            speed: Measurement<UnitSpeed>(value: 5, unit: .knots),
            gustSpeed: Measurement<UnitSpeed>(value: 10, unit: .knots))
    }
}

extension WindScaleValue {
    
    static func randomSpeedsForLevel(_ level:Self) -> (average:Measurement<UnitSpeed>, gust:Measurement<UnitSpeed>?) {
        let speedRange = level.windSpeedMin.value..<level.windSpeedMax.value
        var gustSpeed:Double?
        let speed = Double.random(in:speedRange)
        if (Bool.random()) {
            let lb = (speedRange.upperBound-speedRange.lowerBound)/2
            let up = (speedRange.upperBound * 1.25)
            let gustRange = lb...up
            gustSpeed = Double.random(in: gustRange)
        } else {
            gustSpeed = nil
        }
        
        if let gustSpeed {
            return (average:Measurement<UnitSpeed>(value: speed, unit: .knots), gust:Measurement<UnitSpeed>(value: gustSpeed, unit: .knots))
        } else {
            return (average:Measurement<UnitSpeed>(value: speed, unit: .knots), gust:nil)
        }
    }
    
    static func randomDirectionForLevel(_ level:Self) -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value:Double.random(in:(0.0...360.0)), unit: .degrees)
    }
    
    public static func exampleWindReportForLevel(_ level:Self) -> WindReport{
        let speeds = randomSpeedsForLevel(level)
        return WindReport(
            date: Date.now,
            direction: randomDirectionForLevel(level),
            speed: speeds.average,
            gustSpeed: speeds.gust)
    }
}

    
#endif

