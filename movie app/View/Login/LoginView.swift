//
//  LoginView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI
import NavigationStack

struct LoginView: View {
    @EnvironmentObject var navigationStack: NavigationStackCompat
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                navigationStack.pop()
            }) {
                Image("back")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .padding(.top)
            
            Text("Welcome back 👋")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
                .multilineTextAlignment(.leading)
                .padding(.top, 80)
                .padding(.bottom, 8)
            
            Text("I am so happy to see you again. You can continue to login for more features.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 30)
            
            TextField("Email", text: $viewModel.username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(
                        CircularProgressViewStyle(
                            tint: .blue
                        )
                    )
                    .frame(maxWidth: .infinity)
            } else {
                PrimaryButton(title: "Login", action: {
                    viewModel.login()
                })
            }
            
            HStack {
                Spacer()
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    // Action for sign up
                }) {
                    Text("Sign up")
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding([.horizontal, .bottom])
        .onReceive(viewModel.$success.dropFirst(), perform: { success in
            if success {
                navigationStack.push(MovieListView())
            }
        })
        .alert(isPresented: $viewModel.showingErrorAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(viewModel.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                    viewModel.showingErrorAlert = false
                }
            )
        }
    }
}

#Preview {
    LoginView()
}

