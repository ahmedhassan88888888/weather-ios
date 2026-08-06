//
//  ForecastMapperTests.swift
//  Weather
//
//  Created by Ahmed hassan on 06/08/2026.
//

import XCTest
@testable import Weather

final class ForecastMapperTests: XCTestCase {
    func test_mapToDailyForecasts_groupsEntriesByDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let entry1 = ForecastEntry(dt: today.timeIntervalSince1970, main: MainWeather(temp: 20, feelsLike: 20), weather: [WeatherCondition(description: "clear", icon: "01d")])
        let entry2 = ForecastEntry(dt: today.addingTimeInterval(3600 * 6).timeIntervalSince1970, main: MainWeather(temp: 28, feelsLike: 28), weather: [WeatherCondition(description: "clear", icon: "01d")])

        let response = ForecastResponse(list: [entry1, entry2])
        let result = ForecastMapper.mapToDailyForecasts(response)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.minTemp, 20)
        XCTAssertEqual(result.first?.maxTemp, 28)
    }
}
