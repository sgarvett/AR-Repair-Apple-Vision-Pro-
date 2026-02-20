//
//  ContentView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showGuide = false
    
    var body: some View {
        VStack {
            NavigationMenu()
            ImageRecognizingView()
            ToggleImmersiveSpaceButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
