//
//  AR_Repair_AVPApp.swift
//  AR Repair-AVP
//
//  Created by Samuel Garvett on 1/20/26.
//

import SwiftUI

@main
struct AR_Repair_AVPApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        //automatically resizes the main window to fit all content and allows user to pull corner to readjust as well
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
