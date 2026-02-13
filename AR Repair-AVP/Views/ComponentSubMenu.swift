//
//  MacBookSubMenu.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 2/6/26.
//

import SwiftUI

struct ComponentSubMenu: View {
    
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
                            "Battery Cowling",
    ]
                          
    
    
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(macbook14Components, id: \.self) { component in
                        Button {
                            // Handle tap for `component`
                            print("Tapped \(component)")
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
                .padding(.vertical, 8)
            }
        }
    }
}
        

#Preview {
    ComponentSubMenu()
}
