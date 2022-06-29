//
//  ExampleWeatherView.swift
//  Wind
//
//  Created by Labtanza on 6/24/22.
//

import SwiftUI
import WeatherKit
import CoreLocation


/// A view that displays the temperature in Los Angeles.
struct HelloWeather: View {
    @State var currentLocation = CLLocation(latitude: 34.0536909, longitude: -118.242766)

    /// The current weather condition for the location.
    @State private var condition: WeatherCondition?
    /// Indicates whether it will rain soon.
    @State private var willRainSoon: Bool?
    @State private var cloudCover: Double?
    @State private var temperature: Measurement<UnitTemperature>?
    @State private var symbolName: String?

    @State var locality = "Los Angeles, CA"

    //public init() {}

    var body: some View {
        Group {
            VStack {
                Text(locality)
                Text(temperature?.description ?? "Test")
            }
        }.task() {
            do {
                let weather = try await WeatherService.shared.weather(for: currentLocation)
                condition = weather.currentWeather.condition
                willRainSoon = weather.minuteForecast?.contains(where: { $0.precipitationChance >= 0.3 })
                cloudCover = weather.currentWeather.cloudCover
                temperature = weather.currentWeather.temperature
                symbolName = weather.currentWeather.symbolName


            } catch {
                print("Could not gather weather information...", error.localizedDescription)
                condition = .clear
                willRainSoon = false
                cloudCover = 0.15
            }
        }
       
    }
}

struct ExampleWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HelloWeather()
    }
}
