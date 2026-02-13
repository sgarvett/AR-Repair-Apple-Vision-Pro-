//
//  ImageGridView.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/30/26.
//

import SwiftUI

struct ImageGridView: View {
    let assetNames: [String]

    // 3-column grid; adjust spacing or count as needed
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(assetNames, id: \.self) { name in
                if UIImage(named: name) != nil {
                    
                    VStack(spacing: 6) {
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.quaternary, lineWidth: 0.5))
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        // Caption
                        Text(name)
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                    }
                    
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                        Image(systemName: "photo")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 80)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview("Sample Grid") {
    ImageGridView(assetNames: [
        "T3",
        "T4",
        "T5",
        "SampleImage4",
        "SampleImage5",
        "SampleImage6",
        "SampleImage7",
        "SampleImage8",
        "SampleImage9",
        "SampleImage10",
        "SampleImage11",
        "SampleImage12"
    ])
}
