//
//  WeatherData.swift
//  Wind
//
//  Created by Carlyn Maw on 6/24/22.
//

import WeatherKit
import CoreLocation
import LocationServices

//TODO WeatherData Service taht lets you swap in fake data for real behond that feature for WindReports

final public class WeatherDataService {
    public init() {
        self.location = LocationServices.defaultLocation
    }
    
    
    public static let shared = WeatherDataService()
    private let service = WeatherService.shared
    public private(set) var location:CLLocation
    
    
    public private(set) var cachedDailyForecast:Forecast<DayWeather>?
    public private(set) var cachedDailyReport:WeatherReport?


    
    public func updateCachedWeather() async {
        await updateCachedDailyForecast()
        if let cachedDailyForecast {
            cachedDailyReport = WeatherReport(cachedDailyForecast)
        } else {
            cachedDailyReport = nil
        }
    }
    
    public func updateLocation(to newLocation:CLLocation, refreshing:Bool = true) async {
        location = newLocation
        if refreshing {
            await updateCachedWeather()
        }
    }
    
    func updateCachedDailyForecast() async {
        if let daily = await dailyForcast(for: location) {
            cachedDailyForecast = daily
        }
    }
    
    public var windReport:WindReport? {
        if cachedDailyForecast != nil {
            return WindReport(cachedDailyForecast!)
        } else {
            return nil
        }
    }
    
    @discardableResult
    func weather(for location:CLLocation) async -> CurrentWeather? {
        let currentWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .current)
            return forcast
        }.value
        return currentWeather
    }
    
    @discardableResult
    func dailyForcast(for location:CLLocation) async ->Forecast<DayWeather>? {
        let dayWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .daily)
            return forcast
        }.value
        return dayWeather
    }
    
    @discardableResult
    func hourlyForcast(for location:CLLocation) async ->Forecast<HourWeather>? {
        let hourlyWeather = await Task.detached(priority: .userInitiated) {
            let forcast = try? await self.service.weather(
                for: location,
                including: .hourly)
            return forcast
        }.value
        return hourlyWeather
    }
}

