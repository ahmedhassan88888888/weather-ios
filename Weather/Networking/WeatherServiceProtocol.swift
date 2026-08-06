import Foundation


protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherResponse
    func fetchForecast(city: String) async throws -> ForecastResponse
}
