//
//  LocationPermissionView.swift
//  Weather
//
//  Created by Ahmed hassan on 06/08/2026.
//

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    let status: CLAuthorizationStatus
    let onRequestPermission: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.circle")
                .font(.system(size: 40))
                .foregroundStyle(.blue)

            switch status {
            case .notDetermined:
                Text("Allow location access to see weather near you")
                    .multilineTextAlignment(.center)
                Button("Enable Location", action: onRequestPermission)
            case .denied, .restricted:
                Text("Location access denied. Enable it in Settings to use this feature.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            default:
                EmptyView()
            }
        }
        .padding()
    }
}
