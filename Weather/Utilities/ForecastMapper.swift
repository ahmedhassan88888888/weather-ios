//
//  ForecastMapper.swift
//  Weather
//
//  Created by Ahmed hassan on 06/08/2026.
//

import Foundation

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let description: String
}

enum ForecastMapper {
    static func mapToDailyForecasts(_ response: ForecastResponse) -> [DailyForecast] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: response.list) { entry in
            calendar.startOfDay(for: entry.date)
        }

        return grouped.map { (day, entries) in
            let temps = entries.map { $0.main.temp }
            let mostCommonDescription = entries.first?.weather.first?.description ?? ""
            return DailyForecast(
                date: day,
                minTemp: temps.min() ?? 0,
                maxTemp: temps.max() ?? 0,
                description: mostCommonDescription
            )
        }
        .sorted { $0.date < $1.date }
    }
}
