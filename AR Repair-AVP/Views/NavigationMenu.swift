//
//  NavigationMenu.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI

struct NavigationMenu: View {
    @State private var showMacComponentSubView = false
    @State private var showiPhoneComponentSubView = false
    
    var body: some View {
        HStack(spacing: 16) {
            
            Button(action: { withAnimation {showMacComponentSubView.toggle()} }) {
                Label("Macbook", systemImage: "macbook")
            }
            .buttonStyle(.bordered)
            .popover(isPresented: $showMacComponentSubView,
                     attachmentAnchor: .point(.top),
                     arrowEdge: .top) {
                ComponentSubMenu(device: .macBook14)
                    .frame(minWidth: 350)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding()
                    .glassBackgroundEffect()
            }
            
            
            Button(action: { print("iMac button pressed")}) {
                Label("iMac", systemImage: "desktopcomputer")
            }
            .buttonStyle(.bordered)
            
            Button(action: { withAnimation {showiPhoneComponentSubView.toggle()} }) {
                Label("iPhone", systemImage: "iphone")
            }
            .buttonStyle(.bordered)
            .popover(isPresented: $showiPhoneComponentSubView,
                     attachmentAnchor: .point(.top),
                     arrowEdge: .bottom) {
                ComponentSubMenu(device: .iPhone)
                    .frame(minWidth: 350)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding()
                    .glassBackgroundEffect()
            }
            
                      
        }
        .padding()
    }
}

#Preview {
    VStack {
        Spacer()
        NavigationMenu()
    }
    .padding()
}

