import Foundation
import Observation

enum ViewState {
    case idle
    case loading
    case loaded(WeatherResponse)
    case error(String)
}

@Observable
final class WeatherViewModel {
    private(set) var state: ViewState = .idle
    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol) {
        self.service = service
    }

    func loadWeather(for city: String) async {
        state = .loading
        do {
            let result = try await service.fetchWeather(city: city)
            state = .loaded(result)
        } catch {
            state = .error("Couldn't load weather. Please try again.")
        }
    }
}
