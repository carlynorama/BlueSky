//
//  WeatherDisplayView.swift
//  Wind
//
//  Created by Carlyn Maw on 6/29/22.
//

import SwiftUI

struct WeatherDisplayView: View {
    @StateObject var weather: WeatherMapping
    
    var body: some View {
        VStack(spacing:10) {
            Text ("date: \(weather.weatherDate)")
            Text("gust: \(weather.gustSpeedFactor)")
            Text("speed: \(weather.windSpeedFactor)")
            Text("direction: \(weather.windDirectionFactor)")
            Button("Update Weather") {
                update()
            }
        }
    }
    
    func update() {
        print("update underway")
        Task {
            await weather.updateWeather()
        }
        print("update completed")
    }
}

struct WeatherDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDisplayView(weather: WeatherMapping())
    }
}
