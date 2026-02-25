//
//  WeatherError.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/23.
//

import SwiftUI

public struct WeatherError: View {
    let retryAction: () -> Void
    
    public enum WeatherErrorType {
        case network
        case location
        case unknown
    }
    
    public init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("An error occurred")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
            
            Text("Please check your location settings or try again later.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
            
            HStack {
                Button("Open Settings") {
                    openSettings()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Retry", action: retryAction)
                    .buttonStyle(.bordered)
                    .tint(.white)
            }
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .cornerRadius(12)
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
