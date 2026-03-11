import SwiftUI
import Vision
import Combine

#if os(visionOS)

// MARK: - Corner Bracket Shape
//struct CornerBracketShape: Shape {
//    let cornerLength: CGFloat
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let inset: CGFloat = 1.5
//        let r = rect.insetBy(dx: inset, dy: inset)
//        
//        // Top-left
//        path.move(to: CGPoint(x: r.minX, y: r.minY + cornerLength))
//        path.addLine(to: CGPoint(x: r.minX, y: r.minY))
//        path.addLine(to: CGPoint(x: r.minX + cornerLength, y: r.minY))
//        
//        // Top-right
//        path.move(to: CGPoint(x: r.maxX - cornerLength, y: r.minY))
//        path.addLine(to: CGPoint(x: r.maxX, y: r.minY))
//        path.addLine(to: CGPoint(x: r.maxX, y: r.minY + cornerLength))
//        
//        // Bottom-right
//        path.move(to: CGPoint(x: r.maxX, y: r.maxY - cornerLength))
//        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
//        path.addLine(to: CGPoint(x: r.maxX - cornerLength, y: r.maxY))
//        
//        // Bottom-left
//        path.move(to: CGPoint(x: r.minX + cornerLength, y: r.maxY))
//        path.addLine(to: CGPoint(x: r.minX, y: r.maxY))
//        path.addLine(to: CGPoint(x: r.minX, y: r.maxY - cornerLength))
//        
//        return path
//    }
//}

// MARK: - Highlight Box View
struct HighlightBoxView: View {
    var label: String?
    var color: Color = .yellow
    var lineWidth: CGFloat = 2.0
    var cornerLength: CGFloat = 20.0
    var isAnimating: Bool = true
    
    @State private var isPulsing = false
    @State private var isVisible = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(isPulsing ? 0.05 : 0.15))
            RoundedRectangle(cornerRadius: 4)
                .stroke(style: StrokeStyle(
                    lineWidth: lineWidth,
                    dash: [6, 3]
                ))
//                .foregroundStyle(color.opacity(isPulsing ? 0.5 : 1.0))
//            CornerBracketShape(cornerLength: cornerLength)
//                .stroke(style: StrokeStyle(
//                    lineWidth: lineWidth + 1.5,
//                    lineCap: .round
//                ))
//                .foregroundStyle(.white.opacity(isPulsing ? 0.6 : 1.0))
            if let label {
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .offset(y: -24)
                    .padding(.leading, 0)
            }
        }
        .scaleEffect(isVisible ? 1 : 0.85)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) { isVisible = true }
            guard isAnimating else { return }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

// MARK: - Camera Manager (visionOS stub)
@MainActor
class CameraManager: NSObject, ObservableObject {
    @Published var detectedBoxes: [DetectedObject] = []
    
    struct DetectedObject: Identifiable {
        let id: String
        var frame: CGRect
        let label: String
        let color: Color
    }
    
    // Vision request kept for future use if frames are provided by another source
    nonisolated(unsafe) private lazy var detectionRequest: VNDetectRectanglesRequest = {
        let request = VNDetectRectanglesRequest { [weak self] request, _ in
            self?.processResults(request.results)
        }
        request.minimumAspectRatio = 0.2
        request.maximumAspectRatio = 1.0
        request.minimumSize = 0.1
        request.maximumObservations = 5
        return request
    }()
    
    private func processResults(_ results: [VNObservation]?) {
        guard let observations = results as? [VNRectangleObservation] else {
            Task { @MainActor in self.detectedBoxes = [] }
            return
        }
        let boxes = observations.map { obs -> DetectedObject in
            DetectedObject(
                id: obs.uuid.uuidString,
                frame: CGRect(x: 100, y: 100, width: 120, height: 80), // placeholder frame; replace when using real frames
                label: "Object",
                color: .yellow
            )
        }
        Task { @MainActor in self.detectedBoxes = boxes }
    }
}

// MARK: - Main View (visionOS-only)
struct ObjectHighlightView: View {
    @StateObject private var camera = CameraManager()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
               
                // Overlays (will show when detection populates)
                ForEach(camera.detectedBoxes) { object in
                    HighlightBoxView(
                        label: object.label,
                        color: object.color
                    )
                    .frame(width: object.frame.width, height: object.frame.height)
                    .position(x: object.frame.midX, y: object.frame.midY)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                    .id(object.id)
                }
            }
            .animation(.spring(duration: 0.2), value: camera.detectedBoxes.map(\ .id))
        }
        .ignoresSafeArea()
    }
}

// MARK: - Manual Usage (No Camera, great for previews/testing)
struct ManualHighlightDemoView: View {
    let highlights: [(CGRect, String, Color)] = [
        (CGRect(x: 80, y: 360, width: 160, height: 80), "Component", .yellow),
    ]
    
    var body: some View {
        ZStack {
            ForEach(Array(highlights.enumerated()), id: \.offset) { _, item in
                let (rect, label, color) = item
                HighlightBoxView(label: label, color: color)
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX, y: rect.midY)
            }
        }
    }
}

#Preview {
    ManualHighlightDemoView()
}

#else
// Non-visionOS platforms are not supported in this target/file.
struct ObjectHighlightView: View { var body: some View { Text("Unsupported platform") } }
#endif
