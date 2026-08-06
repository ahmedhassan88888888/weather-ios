import SwiftUI
import CoreLocation

struct WeatherView: View {
    @State private var viewModel: WeatherViewModel
    @State private var forecastViewModel: ForecastViewModel
    @State private var locationViewModel: LocationWeatherViewModel
    @State private var cityInput = ""
    @State private var showSettingsPrompt = false

    init(viewModel: WeatherViewModel, forecastViewModel: ForecastViewModel, locationViewModel: LocationWeatherViewModel) {
        _viewModel = State(initialValue: viewModel)
        _forecastViewModel = State(initialValue: forecastViewModel)
        _locationViewModel = State(initialValue: locationViewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    TextField("City (leave empty to use your location)", text: $cityInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    Button("Get Weather") {
                        Task { await handleGetWeather() }
                    }

                    switch viewModel.state {
                    case .idle:
                        Text("Enter a city, or leave empty to use your current location")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    case .loading:
                        LoadingView()
                    case .loaded(let weather):
                        VStack(spacing: 8) {
                            Text(weather.name).font(.title)
                            Text("\(Int(weather.main.temp))°C")
                                .font(.system(size: 50, weight: .bold))
                            Text(weather.weather.first?.description ?? "")
                                .foregroundStyle(.secondary)
                        }
                    case .error(let message):
                        VStack(spacing: 12) {
                            ErrorView(message: message)
                            if showSettingsPrompt {
                                Button("Open Settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }

                    if case .loaded = viewModel.state {
                        switch forecastViewModel.state {
                        case .loaded(let forecasts):
                            ForecastChartView(forecasts: forecasts)
                        case .loading:
                            ProgressView()
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("WeatherNow")
        }
    }

    private func handleGetWeather() async {
        let trimmed = cityInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            do {
                let city = try await locationViewModel.currentCityName()
                showSettingsPrompt = false
                cityInput = city
                await viewModel.loadWeather(for: city)
                await forecastViewModel.loadForecast(for: city)
            } catch LocationServiceError.permissionDenied {
                showSettingsPrompt = true
                viewModel.showError("Location access denied. Enter a city name, or tap below to open Settings.")
            } catch {
                showSettingsPrompt = false
                viewModel.showError("Couldn't determine your location. Please enter a city.")
            }
        } else {
            showSettingsPrompt = false
            await viewModel.loadWeather(for: trimmed)
            await forecastViewModel.loadForecast(for: trimmed)
        }
    }
}
