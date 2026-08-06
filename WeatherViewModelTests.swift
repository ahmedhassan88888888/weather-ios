import XCTest
@testable import Weather
struct FakeWeatherService: WeatherServiceProtocol {
    var result: Result<WeatherResponse, Error>
    var forecastResult: Result<ForecastResponse, Error> = .failure(WeatherServiceError.invalidResponse)

    func fetchWeather(city: String) async throws -> WeatherResponse {
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }

    func fetchForecast(city: String) async throws -> ForecastResponse {
        switch forecastResult {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}

final class WeatherViewModelTests: XCTestCase {
    func test_loadWeather_success_setsLoadedState() async {
        let fakeResponse = WeatherResponse(
            name: "Madrid",
            main: MainWeather(temp: 25.0, feelsLike: 26.0),
            weather: [WeatherCondition(description: "clear sky", icon: "01d")]
        )
        let vm = await WeatherViewModel(service: FakeWeatherService(result: .success(fakeResponse)))

        await vm.loadWeather(for: "Madrid")

        if case .loaded(let weather) = await vm.state {
            XCTAssertEqual(weather.name, "Madrid")
        } else {
            XCTFail("Expected loaded state")
        }
    }

    func test_loadWeather_failure_setsErrorState() async {
        let vm = WeatherViewModel(service: FakeWeatherService(result: .failure(WeatherServiceError.invalidResponse)))

        await vm.loadWeather(for: "Nowhere")

        if case .error = vm.state {
            // pass
        } else {
            XCTFail("Expected error state")
        }
    }
}
