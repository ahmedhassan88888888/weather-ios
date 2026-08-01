import SwiftUI

@main
struct WeatherNowApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel(service: WeatherService(apiKey: Self.apiKey)))
        }
    }

    private static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["OpenWeatherAPIKey"] as? String
        else {
            fatalError("Missing OpenWeatherAPIKey in Secrets.plist")
        }
        return key
    }
}
