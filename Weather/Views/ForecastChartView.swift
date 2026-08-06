import SwiftUI
import Charts

struct ForecastChartView: View {
    let forecasts: [DailyForecast]

    var body: some View {
        Chart(forecasts) { day in
            LineMark(
                x: .value("Day", day.date, unit: .day),
                y: .value("Temp", day.maxTemp),
                series: .value("Type", "Max")
            )
            .foregroundStyle(by: .value("Type", "Max Temp"))
            .symbol(.circle)

            LineMark(
                x: .value("Day", day.date, unit: .day),
                y: .value("Temp", day.minTemp),
                series: .value("Type", "Min")
            )
            .foregroundStyle(by: .value("Type", "Min Temp"))
            .symbol(.circle)
        }
        .chartForegroundStyleScale([
            "Max Temp": .orange,
            "Min Temp": .blue
        ])
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .frame(height: 220)
        .padding()
    }
}
