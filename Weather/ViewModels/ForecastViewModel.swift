//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Ahmed hassan on 06/08/2026.
//

import Foundation
import Observation

@Observable
final class ForecastViewModel {
    private(set) var state: ForecastState = .idle
    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func loadForecast(for city: String) async {
        state = .loading
        do {
            let response = try await service.fetchForecast(city: city)
            let dailyForecasts = ForecastMapper.mapToDailyForecasts(response)
            state = .loaded(dailyForecasts)
        } catch {
            state = .error("Couldn't load forecast. Please try again.")
        }
    }
}

enum ForecastState {
    case idle
    case loading
    case loaded([DailyForecast])
    case error(String)
}
