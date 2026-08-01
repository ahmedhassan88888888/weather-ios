import SwiftUI

struct WeatherView: View {
    @State private var viewModel: WeatherViewModel
    @State private var cityInput = "Madrid"

    init(viewModel: WeatherViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("City", text: $cityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Get Weather") {
                    Task { await viewModel.loadWeather(for: cityInput) }
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

                Spacer()
            }
            .padding(.top)
            .navigationTitle("WeatherNow")
        }
    }
}
