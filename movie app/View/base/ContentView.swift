//
//  ContentView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI
import CoreData
import NavigationStack

struct ContentView: View {
    @EnvironmentObject private var navigationStack: NavigationStackCompat

    var body: some View {
        NavigationStackView {
            OnboardingView()
        }
    }
}
#Preview {
    ContentView()
}
