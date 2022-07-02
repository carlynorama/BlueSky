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
    public static var example:WindReport {
        let levelRaw = Int.random(in: 0...9)
        let windLevel = WindLevel(rawValue: levelRaw)!
        return example(for: windLevel)
    }
    
    public static func example(for windLevel:WindLevel) -> WindReport{
        let speeds = randomSpeeds(for:windLevel)

        return WindReport(
            date: Date.now,
            direction: randomDirection(),
            speed: speeds.average,
            gustSpeed: speeds.gust)
    }
    
    static func randomDirection() -> Measurement<UnitAngle> {
        return Measurement<UnitAngle>(value:Double.random(in:(0.0...360.0)), unit: .degrees)
    }
    
    static func randomSpeeds(for windLevel:WindLevel) -> (average:Measurement<UnitSpeed>, gust:Measurement<UnitSpeed>?) {
        let speedRange = windLevel.windSpeedMin.value..<windLevel.windSpeedMax.value
        var gustSpeed:Double?
        let speed = Double.random(in:speedRange)
        if (Bool.random()) {
            let lb = speed
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
}
    
#endif

