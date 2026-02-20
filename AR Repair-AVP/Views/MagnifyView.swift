//
//  MagnifyView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/14/26.
//

import SwiftUI
import RealityKit

struct MagnifyView: View {
   
    @State private var zoom: CGFloat = 1.0

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(.head)
            content.add(anchor)

            // Example: a reconstructed mesh or overlay entity
            let meshEntity = ModelEntity(mesh: .generatePlane(width: 0.3, height: 0.3))
            meshEntity.position = [0, 0, -0.5]
            anchor.addChild(meshEntity)

        } update: { content in
            // Apply zoom to your augmented content
            let scale = Float(zoom)
            content.entities.first?.scale = [scale, scale, scale]
        }
        .frame(width: 350, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.8), lineWidth: 3)
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    // Clamp zoom between 1.0 and 5.0 while adjusting with pinch
                    let newZoom = min(max(1.0, zoom * value), 5.0)
                    zoom = newZoom
                }
        )
        .overlay(alignment: .bottom) {
            HStack {
                Image(systemName: "minus.magnifyingglass")
                Slider(value: $zoom, in: 1.0...5.0)
                Image(systemName: "plus.magnifyingglass")
            }
            .padding(8)
            .background(.ultraThinMaterial, in: Capsule())
            .padding()
        }
    }
}


#Preview {
    MagnifyView()
}
