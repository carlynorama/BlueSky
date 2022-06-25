//
//  ExampleWeatherView.swift
//  Wind
//
//  Created by Labtanza on 6/24/22.
//

import SwiftUI
import WeatherKit


public struct ExampleWeatherView: View {
    @State var currentLocation = LocationStore.locations[0]
    
    /// The current weather condition for the location.
    @State private var condition: WeatherCondition?
    /// Indicates whether it will rain soon.
    @State private var willRainSoon: Bool?
    @State private var cloudCover: Double?
    @State private var temperature: Measurement<UnitTemperature>?
    @State private var symbolName: String?
    
    @State var locality:String?
    
    public var body: some View {
        Group {
            VStack {
                Text(locality ?? "Place name not found")
                Text(temperature?.description ?? "Test")
                
            }.overlay(alignment: .bottomTrailing) {
                if let currentWeatherCondition = condition, let willRainSoon = willRainSoon, let symbolName = symbolName {
                    WeatherDisplayCard(
                        condition: currentWeatherCondition,
                        willRainSoon: willRainSoon,
                        symbolName: symbolName
                    )
                    .padding(.bottom)
                }
            }
        }.task() {
            do {
                let weather = try await WeatherService.shared.weather(for: currentLocation.cllocation)
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
        .task {
            do {
                locality = try await currentLocation.placemarkDescription
            } catch {
                
            }
        }
    }
}

struct ExampleWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleWeatherView()
    }
}
