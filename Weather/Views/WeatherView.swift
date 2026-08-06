import SwiftUI

struct WeatherView: View {
    @State private var viewModel: WeatherViewModel
    @State private var forecastViewModel: ForecastViewModel
    @State private var cityInput = "Madrid"

    init(viewModel: WeatherViewModel, forecastViewModel: ForecastViewModel) {
        _viewModel = State(initialValue: viewModel)
        _forecastViewModel = State(initialValue: forecastViewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("City", text: $cityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Get Weather") {
                    Task {
                        await viewModel.loadWeather(for: cityInput)
                        await forecastViewModel.loadForecast(for: cityInput)
                    }
                }

                switch viewModel.state {
                case .idle:
                    Text("Enter a city to see the weather")
                        .foregroundStyle(.secondary)
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
                    ErrorView(message: message)
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

                Spacer()
            }
            .padding(.top)
            .navigationTitle("WeatherNow")
        }
    }
}
