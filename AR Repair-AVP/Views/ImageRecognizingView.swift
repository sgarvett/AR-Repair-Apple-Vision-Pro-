//
//  ImageRecognizingView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/18/26.
//

import SwiftUI
import Vision
import CoreML
import UIKit

struct ImageRecognizingView: View {
    @State private var showAlert = false
    @State private var detectedLable = ""
    
    private static let sharedModel: VNCoreMLModel = {
        do {
            let configuration = MLModelConfiguration()
            let classifier = try AppleProductsClassifier(configuration: configuration)
            let coreMLModel = classifier.model
            return try VNCoreMLModel(for: coreMLModel)
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }()
    
    private var model: VNCoreMLModel { Self.sharedModel }
    
    func analyze(image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let request = VNCoreMLRequest(model: model) { request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first, top.confidence > 0.8 else { return }
            
            DispatchQueue.main.async {
                showAlert = true
                detectedLable = top.identifier
            }
        }
        
        try? VNImageRequestHandler(ciImage: ciImage, options: [:]).perform([request])
    }
    
    var body: some View {
        Text("Detection Running...")
            .alert("Item Detected!", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(detectedLable) has been detected.")
            }
    }
}



#Preview {
    ImageRecognizingView()
}

