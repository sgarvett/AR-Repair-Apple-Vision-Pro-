//
//  ComponentTracker.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/12/26.

import SwiftUI
import RealityKit
import ARKit

// MARK: - MacBook Tracker View Component
/// Use this in your existing SwiftUI views
struct MacBookTrackerView: View {
    @State private var tracker = MacBookTracker()
    var onDetectionChange: ((Bool) -> Void)?
    
    var body: some View {
        RealityView { content in
            content.add(tracker.rootEntity)
        }
        .task {
            await tracker.start()
        }
        .task {
            await tracker.monitorTracking { isTracking in
                onDetectionChange?(isTracking)
            }
        }
    }
}

// MARK: - MacBook Tracker Model
@Observable
class MacBookTracker {
    let rootEntity = Entity()
    private let session = ARKitSession()
    private var imageTracking: ImageTrackingProvider?
    private var isCurrentlyTracking = false
    
    /// Configuration for the reference image
    struct Config {
        var imageName: String = "macbook14"  // Image name in Assets
        var physicalWidth: Float = 0.30              // Width in meters
        
        // Highlight configuration
        var highlightColor: UIColor = .red
        var highlightPosition: SIMD3<Float> = SIMD3(x: -0.25, y: 0.002, z: 0.15)
        var highlightSize: SIMD2<Float> = SIMD2(x: 0.18, y: 0.18)
        var showLabel: Bool = true
        var labelText: String = "Fan"
    }
    
    var config = Config()
    
    /// Start AR tracking
    func start() async {
        guard ARKitSession.isSupported else {
            print("[MacBookTracker] ARKit not supported")
            return
        }
        
        let auth = await session.requestAuthorization(for: [.worldSensing])
        guard auth[.worldSensing] == .allowed else {
            print("[MacBookTracker] World sensing not authorized")
            return
        }
        
        guard let refImage = createReferenceImage() else {
            print("[MacBookTracker] Failed to create reference image")
            return
        }
        
        imageTracking = ImageTrackingProvider(referenceImages: [refImage])
        
        guard let tracking = imageTracking else { return }
        
        do {
            try await session.run([tracking])
            print("[MacBookTracker] Session started")
        } catch {
            print("[MacBookTracker] Failed to run session: \(error)")
        }
    }
    
    /// Stop AR tracking
    func stop() {
        session.stop()
        rootEntity.children.removeAll()
        print("[MacBookTracker] Session stopped")
    }
    
    /// Monitor tracking status
    func monitorTracking(callback: @escaping (Bool) -> Void) async {
        guard let tracking = imageTracking else { return }
        
        for await update in tracking.anchorUpdates {
            await handleUpdate(update, callback: callback)
        }
    }
    
    /// Add a custom highlight at a specific position
    func addHighlight(
        at position: SIMD3<Float>,
        size: SIMD2<Float>,
        color: UIColor,
        label: String? = nil
    ) {
        guard let anchorEntity = rootEntity.children.first as? Entity else { return }
        
        let highlight = createHighlightBox(width: size.x, height: size.y, color: color)
        highlight.position = position
        anchorEntity.addChild(highlight)
        
        if let labelText = label {
            let labelEntity = createTextLabel(labelText, color: color)
            labelEntity.position = SIMD3(
                x: position.x,
                y: position.y + 0.013,
                z: position.z + size.y / 2 + 0.02
            )
            anchorEntity.addChild(labelEntity)
        }
    }
    
    /// Clear all highlights
    func clearHighlights() {
        rootEntity.children.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func createReferenceImage() -> ReferenceImage? {
        guard let image = UIImage(named: config.imageName),
              let cgImage = image.cgImage else {
            print("[MacBookTracker] Could not load image: \(config.imageName)")
            return nil
        }
        
        return ReferenceImage(cgImage, physicalWidth: CGFloat(config.physicalWidth))
    }
    
    private func handleUpdate(_ update: AnchorUpdate<ImageAnchor>, callback: @escaping (Bool) -> Void) async {
        await MainActor.run {
            switch update.event {
            case .added:
                isCurrentlyTracking = true
                callback(true)
                addDefaultHighlight(for: update.anchor)
                
            case .updated:
                updateHighlight(for: update.anchor)
                
            case .removed:
                isCurrentlyTracking = false
                callback(false)
                removeHighlight(for: update.anchor)
            }
        }
    }
    
    private func addDefaultHighlight(for anchor: ImageAnchor) {
        rootEntity.children.removeAll()
        
        let anchorEntity = Entity()
        anchorEntity.name = anchor.id.uuidString
        anchorEntity.transform = Transform(matrix: anchor.originFromAnchorTransform)
        
        // Get dimensions
        let width = Float(anchor.referenceImage.physicalWidth)
        let aspectRatio = Float(anchor.referenceImage.image.height) / Float(anchor.referenceImage.image.width)
        let height = width * aspectRatio
        
        // Create highlight
        let highlight = createHighlightBox(
            width: width * config.highlightSize.x,
            height: height * config.highlightSize.y,
            color: config.highlightColor
        )
        
        highlight.position = SIMD3(
            x: width * config.highlightPosition.x,
            y: config.highlightPosition.y,
            z: height * config.highlightPosition.z
        )
        
        anchorEntity.addChild(highlight)
        
        // Add label if enabled
        if config.showLabel {
            let label = createTextLabel(config.labelText, color: config.highlightColor)
            label.position = SIMD3(
                x: width * config.highlightPosition.x,
                y: 0.015,
                z: height * config.highlightPosition.z + (height * config.highlightSize.y / 2) + 0.02
            )
            anchorEntity.addChild(label)
        }
        
        rootEntity.addChild(anchorEntity)
    }
    
    private func updateHighlight(for anchor: ImageAnchor) {
        guard let anchorEntity = rootEntity.children.first(where: { $0.name == anchor.id.uuidString }) else {
            return
        }
        anchorEntity.transform = Transform(matrix: anchor.originFromAnchorTransform)
    }
    
    private func removeHighlight(for anchor: ImageAnchor) {
        if let anchorEntity = rootEntity.children.first(where: { $0.name == anchor.id.uuidString }) {
            anchorEntity.removeFromParent()
        }
    }
    
    private func createHighlightBox(width: Float, height: Float, color: UIColor) -> Entity {
        let thickness: Float = 0.003
        let container = Entity()
        
        let edges: [(SIMD3<Float>, SIMD3<Float>)] = [
            (SIMD3(0, 0, height/2), SIMD3(width, thickness, thickness)),
            (SIMD3(0, 0, -height/2), SIMD3(width, thickness, thickness)),
            (SIMD3(-width/2, 0, 0), SIMD3(thickness, thickness, height)),
            (SIMD3(width/2, 0, 0), SIMD3(thickness, thickness, height))
        ]
        
        for (position, size) in edges {
            let mesh = MeshResource.generateBox(size: size)
            var material = UnlitMaterial(color: color)
            material.blending = .transparent(opacity: 0.9)
            
            let edge = ModelEntity(mesh: mesh, materials: [material])
            edge.position = position
            container.addChild(edge)
        }
        
        return container
    }
    
    private func createTextLabel(_ text: String, color: UIColor) -> Entity {
        let mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.001,
            font: .systemFont(ofSize: 0.015),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
        
        var material = UnlitMaterial(color: color)
        material.blending = .transparent(opacity: 1.0)
        
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        textEntity.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3(x: 1, y: 0, z: 0))
        
        return textEntity
    }
}

// MARK: - Convenience Extensions

extension MacBookTracker {
    /// Preset positions for common MacBook components
    enum ComponentPosition {
        case leftFan
        case rightFan
        case logicBoard
        case battery1
        case battery2
        case battery3
        case leftSpeaker
        case rightSpeaker
        
        func position(width: Float, height: Float) -> SIMD3<Float> {
            switch self {
            case .leftFan:
                return SIMD3(x: -width * 0.25, y: 0.002, z: height * 0.15)
            case .rightFan:
                return SIMD3(x: width * 0.25, y: 0.002, z: height * 0.15)
            case .logicBoard:
                return SIMD3(x: 0, y: 0.002, z: height * 0.05)
            case .battery1:
                return SIMD3(x: -width * 0.3, y: 0.002, z: -height * 0.3)
            case .battery2:
                return SIMD3(x: -width * 0.15, y: 0.002, z: -height * 0.3)
            case .battery3:
                return SIMD3(x: 0, y: 0.002, z: -height * 0.3)
            case .leftSpeaker:
                return SIMD3(x: -width * 0.38, y: 0.002, z: -height * 0.35)
            case .rightSpeaker:
                return SIMD3(x: width * 0.38, y: 0.002, z: -height * 0.35)
            }
        }
        
        var defaultSize: SIMD2<Float> {
            switch self {
            case .leftFan, .rightFan:
                return SIMD2(x: 0.15, y: 0.15)
            case .logicBoard:
                return SIMD2(x: 0.25, y: 0.2)
            case .battery1, .battery2, .battery3:
                return SIMD2(x: 0.12, y: 0.2)
            case .leftSpeaker, .rightSpeaker:
                return SIMD2(x: 0.1, y: 0.08)
            }
        }
        
        var defaultColor: UIColor {
            switch self {
            case .leftFan, .rightFan:
                return .red
            case .logicBoard:
                return .blue
            case .battery1, .battery2, .battery3:
                return .green
            case .leftSpeaker, .rightSpeaker:
                return .purple
            }
        }
    }
}
