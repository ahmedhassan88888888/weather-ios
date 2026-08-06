import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}

struct ForecastResponse: Codable {
    let list: [ForecastEntry]
}

struct ForecastEntry: Codable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]

    var date: Date {
        Date(timeIntervalSince1970: dt)
    }
}
