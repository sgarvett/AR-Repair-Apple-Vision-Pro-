//
//  ImmersiveView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                if let skyboxEntity = try? await Entity(named: "Skybox", in: realityKitContentBundle) {
                    content.add(skyboxEntity)
                }
                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
        
        .frame(width: 200, height: 200)
        
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
