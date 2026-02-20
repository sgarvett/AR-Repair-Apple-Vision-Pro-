//
//  OverlayShape.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/19/26.
//

import SwiftUI
import RealityKit

struct OverlayShape: View {
    var body: some View {
        RealityView { content in
            // Create a semi-transparent 10cm x 10cm plane
            let size: Float = 0.5
            let mesh = MeshResource.generatePlane(width: size, height: size)

            var material = SimpleMaterial()
            material.color = .init(tint: .init(red: 248, green: 215, blue: 72, alpha: 0.4), texture: nil)

            let shapeEntity = ModelEntity(mesh: mesh, materials: [material])

            // Position it in front of the user a bit so it's visible
            // Adjust Z to place further/closer; Y to raise/lower
            shapeEntity.position = [0, 0, -0.5]

            // Optionally give it a slight tilt
            // shapeEntity.orientation = simd_quatf(angle: .pi / 12, axis: [1, 0, 0])

            // Add to the scene's content
            content.add(shapeEntity)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OverlayShape()
}
