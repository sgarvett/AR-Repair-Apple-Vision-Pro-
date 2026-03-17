//
//  MacBookSubMenu.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/6/26.
//

import SwiftUI

struct ComponentSubMenu: View {
    @Environment(\.openWindow) private var openWindow

    enum DeviceType {
        case macBook14
        case iMac
        case iPhone
    }

    let device: DeviceType
    
    
    // Repair types according to device being repaired
    let macbook14Components = [
                            "Bottom Case",
                           "Battery Management Unit Flex Cable",
                           "Lid Angle Sensor",
                           "Trackpad and Trackpad Flex Cable",
                           "Vent/Antenna Module",
                           "Logic Board",
                           "Speakers",
                           "Audio Board",
                           "MagSafe 3 Board",
                            "Touch ID",
                            "IO Boards",
                           "Display Hinge Covers",
                           "Display",
                           "Fans",
                          "Top Case",
    ]
    
    let iMacComponents = ["Display",
                          "Display Cables",
                          "Logic Board Shield"
    ]
    
    let iPhoneComponents = ["Security Screws",
                            "Display",
                            "Battery Screws",
                            "Battery Cowling",
    ]
                          
    private var components: [String] {
        switch device {
        case .macBook14:
            return macbook14Components
        case .iMac:
            return iMacComponents
        case .iPhone:
            return iPhoneComponents
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(components, id: \.self) { component in
                        if component == "Top Case" {
                            Button {
                                
                                // On visionOS, open a brand new window for the Top Case flow.
                                openWindow(id: "StepByStepGuide")
                            } label: {
                                HStack {
                                    Text(component)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            NavigationLink {
                                Text("\(component) details coming soon")
                                    .padding()
                                    .navigationTitle(component)
                            } label: {
                                HStack {
                                    Text(component)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
            .navigationTitle(title(for: device))
        
        }
    }
    
    private func title(for device: DeviceType) -> String {
        switch device {
        case .macBook14: return "MacBook Pro 14\u{201D} Components"
        case .iMac: return "iMac Components"
        case .iPhone: return "iPhone Components"
        }
    }
}
        

#Preview {
    ComponentSubMenu(device: .macBook14)
}

