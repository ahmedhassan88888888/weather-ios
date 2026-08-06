import Foundation
import CoreLocation

@Observable
final class LocationWeatherViewModel {
    private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }

    func currentCityName() async throws -> String {
        var status = locationService.authorizationStatus

        if status == .notDetermined {
            status = await locationService.requestPermissionAndWait()
        }

        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationServiceError.permissionDenied
        }

        let coordinate = try await locationService.requestCurrentLocation()
        return try await reverseGeocode(coordinate)
    }

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async throws -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let city = placemarks.first?.locality else {
            throw LocationServiceError.locationUnavailable
        }
        return city
    }
}
