# WeatherNow

A SwiftUI weather app with async networking, 5-day forecast charts, and current-location detection.

## Status
✅ Complete

## Tech Stack
- SwiftUI, Swift 5.9+, async/await
- Architecture: MVVM + Repository Pattern
- CoreLocation for current-location weather
- Swift Charts for 5-day forecast visualization
- Testing: XCTest with protocol-based mocking

## Features
- Search weather by city name
- Current-location weather with graceful permission handling
- 5-day forecast chart (min/max temperature)
- Secure API key handling via untracked Secrets.plist

## Setup
1. Get a free API key from openweathermap.org
2. Add it to `Resources/Secrets.plist` as `OpenWeatherAPIKey`
3. Open in Xcode 15+, Cmd+R
