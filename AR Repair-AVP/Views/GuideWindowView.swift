//
//  GuideWindowView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI

struct Step {
    let title: String
    let description: String
    let imageName: String?
}

struct StepByStepGuide: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    let steps = [
        Step(title: "tools needed to replace top case", description: "Let's get started with setup. These are the tools you'll need.", imageName: "wrench.and.screwdriver"),
        Step(title: "remove bottom case screws", description: "You will need (tool name) to remove screws.", imageName: ""),
        Step(title: "remove battery management unit flex cable", description: "Gently fold back the trackpad flex cable.", imageName: ""),
        Step(title: "disconnect BMU flex cable", description: "Use ESD-safe tweezers to gently slide the end of th the connector", imageName: ""),
        Step(title: "remove trackpad and flex cable", description: "First, place the display to a 90º angle, then disconnect flex cable, finally remove trackpad screws", imageName: ""),
        Step(title: "remove vent/antenna module", description: "remove antenna coaxial cable connector cowling", imageName: ""),
        Step(title: "remove antenna screws", description: "Remove the nine 1IPR screws then lift antenna", imageName: ""),
        Step(title: "remove logic board", description: "Romove speakers screws and cowling", imageName: ""),
        Step(title: "cowling removal", description: "Use 3IP bit to remove eight cowlings", imageName: ""),
    ]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack(spacing: 20) {
                // Explicit Close button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.yellow).opacity(0.8)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 480)
                
                
                
                // Current step content
                if let imageName = steps[currentStep].imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                }
                
                
                
                Text(steps[currentStep].title)
                    .font(.title.smallCaps())
                    .bold()
                
                // inserts image grid only for the first step
                if currentStep == 0 {
                    ImageGridView(assetNames: [
                        "SuctionCup",
                        "Blackstick",
                        "BatteryCover",
                        "CalibrationWeights",
                        "ESDSafeTweezers",
                        "ESDWristStrapAndCable",
                        "Pentalobe",
                        "T3",
                        "T4",
                        "T5",
                        "T6",
                        "T8",
                    ])
                } else {
                    if let imageName = steps[currentStep].imageName, !imageName.isEmpty {
                        Image(imageName) // asset image for other steps
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .padding(8)
                    }
                }
                
                Text(steps[currentStep].description)
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Progress bar
                ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                    .progressViewStyle(.linear)
                    .tint(.yellow)
                    .padding()
                    .frame(maxWidth: 500)
                
                // Navigation
                HStack(spacing: 16) {
                    Button("Back") {
                        if currentStep > 0 {
                            currentStep -= 1
                        }
                    }
                    .disabled(currentStep == 0)
                    .buttonStyle(.bordered)
                    .keyboardShortcut(.leftArrow, modifiers: [])
                    
                    Button(currentStep < steps.count - 1 ? "Next" : "Finish") {
                        if currentStep < steps.count - 1 {
                            currentStep += 1
                        } else {
                            // Handle completion
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.rightArrow, modifiers: [])
                }
                .padding()
            }
            .padding()
            .animation(.easeInOut, value: currentStep) // Smooth transitions
        }
    }
}




#Preview {
    StepByStepGuide()
}

