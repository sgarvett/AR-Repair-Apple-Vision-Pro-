//
//  AppModel.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI
import ARKit
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    let rootEntity = Entity()
    
    // Image tracking from photo of real life object.
    let session = ARKitSession()
    private var anchorEntities: [UUID: AnchorEntity] = [:]
    
    private let imageTracking = ImageTrackingProvider(referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "AR Resources", bundle: .main))
        
    private func makeHighlightBox(for anchor: ImageAnchor) -> ModelEntity {
            let mesh = MeshResource.generateBox(size: SIMD3(0.3, 0.001, 0.3))
            var material = UnlitMaterial()
            material.color = .init(tint: .yellow.withAlphaComponent(0.4))
            return ModelEntity(mesh: mesh, materials: [material])
        }
        
        func startTracking(in rootEntity: Entity) async {
            guard ImageTrackingProvider.isSupported else {
print("❌ ImageTrackingProvider not supported")
                return
            }
            
            do {
                try await session.run([imageTracking])
print("✅ Session running")
            } catch {
print("❌ Session error: \(error)")
                return
            }
            
            for await update in imageTracking.anchorUpdates {
                let anchor = update.anchor
print("✅ Event: \(update.event) | name: \(anchor.referenceImage.name ?? "nil") | isTracked: \(anchor.isTracked)")
                
                switch update.event {
                case .added, .updated:
                    if anchorEntities[anchor.id] == nil {
                        // Fixed: use world transform instead of .image anchor
                        let anchorEntity = AnchorEntity(world: simd_float4x4(1))
                        anchorEntity.addChild(makeHighlightBox(for: anchor))
                        rootEntity.addChild(anchorEntity)
                        anchorEntities[anchor.id] = anchorEntity
print("✅ Box created, rootEntity children: \(rootEntity.children.count)")
                    }
                    
                    // Always update transform and visibility
                    anchorEntities[anchor.id]?.setTransformMatrix(
                        anchor.originFromAnchorTransform,
                        relativeTo: nil
                    )
                    // Lay flat and offset down to sit on surface
                                var transform = anchorEntities[anchor.id]?.transform ?? Transform()
                                transform.translation.y -= 0.05
                                transform.rotation = simd_quatf(angle: -.pi / 2, axis: SIMD3(1, 0, 0))
                    anchorEntities[anchor.id]?.isEnabled = anchor.isTracked
                    
                case .removed:
                    anchorEntities[update.anchor.id]?.removeFromParent()
                    anchorEntities.removeValue(forKey: update.anchor.id)
                }
            }
        }
    }
