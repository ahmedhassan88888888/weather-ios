import CoreLocation

enum LocationServiceError: Error {
    case permissionDenied
    case locationUnavailable
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    var authorizationStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }


    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }

    // Naya delegate method (iOS 14+)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        resumePermissionIfNeeded(manager.authorizationStatus)
    }

    // Purana delegate method — simulator/kuch iOS versions isko use karte hain
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        resumePermissionIfNeeded(status)
    }

    private func resumePermissionIfNeeded(_ status: CLAuthorizationStatus) {
        guard let continuation = permissionContinuation else { return }
        permissionContinuation = nil
        continuation.resume(returning: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: LocationServiceError.locationUnavailable)
            locationContinuation = nil
            return
        }
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
    func requestPermissionAndWait() async -> CLAuthorizationStatus {
        guard authorizationStatus == .notDetermined else {
            return authorizationStatus
        }
        return await withCheckedContinuation { continuation in
            self.permissionContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }
}
