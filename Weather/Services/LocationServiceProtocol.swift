//
//  LocationServiceProtocol.swift
//  Weather
//
//  Created by Ahmed hassan on 06/08/2026.
//

import CoreLocation

import CoreLocation

protocol LocationServiceProtocol {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestPermissionAndWait() async -> CLAuthorizationStatus
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D
}
