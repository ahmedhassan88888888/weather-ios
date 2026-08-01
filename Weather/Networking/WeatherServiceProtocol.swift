import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> WeatherResponse
}
