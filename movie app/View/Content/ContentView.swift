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
    @StateObject private var viewModel = ContentViewModel()
    @State private var showBiometricPrompt = false

    var body: some View {
        NavigationStackView {
            if viewModel.isUserLoggedIn {
                MovieListView()
            } else {
                OnboardingView()
            }
        }
    }
}


#Preview {
    ContentView()
}
