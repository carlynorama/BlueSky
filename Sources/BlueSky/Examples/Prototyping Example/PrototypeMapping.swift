//
//  File.swift
//  
//
//  Created by Labtanza on 7/3/22.
//

import Foundation

extension BlueSky {
    //TODO: Actor-isolated property can not be mutated error... but it's the int???, reverted to class from actor.
    final class PrototypeMapping:ObservableObject {
        var weatherSource:WeatherData
        
        //@Published private(set) var windReport:WindReport?
        //Should be private set in a normal situation
        @Published var windReport:MutatingWindReport = MutatingWindReport(from: WindReport.example(for: .freshBreeze))
        
        
        public init() {
            weatherSource = WeatherData.shared
            let tmp = MutatingWindReport(from: WeatherData.shared.windReport ?? WindReport.example(for: .freshBreeze))
            self.windReport = tmp
            print("PWM init: speed \(tmp.speed.description)")
            print("PWM init: wind level \(tmp.windLevel.description)")
            self.gustForBinding = tmp.gustSpeedAsMPS ?? 0.0
        }
        
        var locationName:String {
            "Los Angeles"
        }
        
//        TODO: async fetch of name, do this inside WeatherData??
//        func fetchLocationName() -> String {
//            Task {
//                await weatherSource.location.placemarkDescription?.description ?? "Unkown Location"
//            }
//        }
        
        func updateWeather() async {
            await weatherSource.updateCachedWeather()
            windReport = MutatingWindReport(from: weatherSource.windReport ?? WindReport.example(for: .freshBreeze))
        }
        
        var gustsDefined:Bool {
            windReport.gustSpeed != nil
        }
        
        @Published var gustForBinding:Double {
            willSet {
                windReport.gustSpeed = Measurement<UnitSpeed>(value:newValue, unit:.metersPerSecond)
            }
        }
        
        @Published var useGustSpeedIfAvailable:Bool = true
        
        //MARK: For Mapping to Weather Vane Behavior
        @Published var directionShift = -Double.pi/2 // THIS IS CORRECT
        @Published var mpsToMagnitude:Double = 0.01
        //Birthrate, wobblyness
        
        public var directionForParticleSystem:Double {
            (windReport.directionAsRadians) + directionShift
        }
        public var magnitudeForParticleSystem:Double {
            if useGustSpeedIfAvailable {
                return (windReport.gustSpeedAsMPS ?? windReport.speedAsMPS) * mpsToMagnitude
            } else {
                return windReport.speedAsMPS * mpsToMagnitude
            }
        }
        
        
    }
    
}
