//
//  MagnifyView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/14/26.
//

import SwiftUI

struct MagnifyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
            
            Text("Need to see small parts?")
                .font(.title)
            
            Text("Enable Zoom in Settings for magnification")
                .multilineTextAlignment(.center)
            
            Button("Open Accessibility Settings") {
                if let url = URL(string: "App-prefs:root=ACCESSIBILITY") {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Fallback instructions
            VStack(alignment: .leading, spacing: 10) {
                Text("To enable Zoom manually:")
                    .font(.headline)
                Text("1. Open Settings")
                Text("2. Go to Accessibility")
                Text("3. Select Zoom")
                Text("4. Turn on Zoom")
                Text("5. Use Digital Crown to adjust zoom level")
            }
            .font(.caption)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    MagnifyView()
}
