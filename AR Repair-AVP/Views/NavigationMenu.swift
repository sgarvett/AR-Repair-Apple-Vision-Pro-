//
//  NavigationMenu.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI

struct NavigationMenu: View {
    @State private var showGuide = false
    @State private var showSubMenu = false
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: { showGuide = true }) {
                Label("Macbook", systemImage: "macbook")
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: { print("iMac button pressed")}) {
                Label("iMac", systemImage: "desktopcomputer")
            }
            .buttonStyle(.bordered)
            
            Button(action: { withAnimation {showSubMenu.toggle() } }) {
                Label("iPhone", systemImage: "iphone")
            }
            .buttonStyle(.bordered)
            .popover(isPresented: $showSubMenu,
                     attachmentAnchor: .point(.bottom),
                     arrowEdge: .bottom) {
                ComponentSubMenu()
                    .frame(minWidth: 350)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding()
                    .glassBackgroundEffect()
            }
                      
        }
        .padding()
        .sheet(isPresented: $showGuide) {
            StepByStepGuide()
        }
    }
}

#Preview {
    VStack {
        Spacer()
        NavigationMenu()
    }
    .padding()
}

