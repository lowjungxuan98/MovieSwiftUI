//
//  MovieApp.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

@main
struct MovieApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    @State var isBlur: Bool = false

    var body: some Scene {        
        WindowGroup {
            ContentView()
                .blur(radius: isBlur ? 10 : 0)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
            if AuthenticationManager.shared.isRequired || isBlur {
                AuthenticationManager.shared.authenticateUser { success in
                    isBlur = !success
                }
                AuthenticationManager.shared.isRequired = false
            }
        }
    }
}
