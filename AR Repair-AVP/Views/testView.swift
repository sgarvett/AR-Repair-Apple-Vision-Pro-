//
//  testView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 3/26/26.
//

import SwiftUI
    
struct testView: View {
    
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
            }
        }
    }

#Preview {
    testView()
}
