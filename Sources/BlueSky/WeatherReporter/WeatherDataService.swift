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
    public static let defaultLocation = CLLocation(
        latitude: 34.0536909,
        longitude: -118.242766)
    
    public init() { }
    
    
    public static let shared = WeatherDataService()
    private let service = WeatherService.shared
    
    
    struct WeatherRequestDailyResult {
        let location:CLLocation
        let forcast:Forecast<DayWeather>
    }
    
    private var cachedDailyForecast:WeatherRequestDailyResult?
    public private(set) var cachedDailyReport:WeatherReport?
    
    public func windReport(for location:CLLocation) async -> WindReport? {
        //A) Is there cached data
        //B) Is it stale
        //C) If it isn't there or it's stale...
        await updateCachedWeather(for: location)
        return WindReport(cachedDailyReport)
    }
    
    
    public func updateCachedWeather(for location:CLLocation) async {
        await updateCachedDailyForecast(for: location)
        if let cachedDailyForecast {
            cachedDailyReport = WeatherReport(cachedDailyForecast.forcast, for: cachedDailyForecast.location)
        } else {
            cachedDailyReport = nil
        }
    }
    
//    public func updateLocation(to newLocation:CLLocation, refreshing:Bool = true) async {
//        location = newLocation
//        if refreshing {
//            await updateCachedWeather()
//        }
//    }
    
    func updateCachedDailyForecast(for location:CLLocation) async {
        if let daily = await dailyForcast(for: location) {
            cachedDailyForecast = WeatherRequestDailyResult(location: location, forcast: daily)
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

