//
//  WeatherData.swift
//  Wind
//
//  Created by Labtanza on 6/24/22.
//

import WeatherKit
import CoreLocation


class WeatherData {
    static let shared = WeatherData() //What does this line do?
    private let service = WeatherService.shared
    
    @discardableResult
    func weather(for location:Location) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location.cllocation,
                including: .current)
            return forcast
        }.value
        return currentWeather
    }
    
    @discardableResult
    func dailyForcast(for location:Location) async ->Forecast<DayWeather>? {
        let dayWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location.cllocation,
                including: .daily)
            return forcast
        }.value
        return dayWeather
    }
    
    @discardableResult
    func hourlyForcast(for location:Location) async ->Forecast<HourWeather>? {
        let hourlyWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location.cllocation,
                including: .hourly)
            return forcast
        }.value
        return hourlyWeather
    }
}
