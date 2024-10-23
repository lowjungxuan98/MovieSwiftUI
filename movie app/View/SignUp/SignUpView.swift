//
//  SignUpView.swift
//  movie app
//
//  Created by Low Jung Xuan on 23/10/2024.
//

import SwiftUI
import NavigationStack

struct SignUpView: View {
    @EnvironmentObject var navigationStack: NavigationStackCompat
    @StateObject private var viewModel = SignUpViewModel()

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

            Text("Create an Account 👋")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
                .multilineTextAlignment(.leading)
                .padding(.top, 80)
                .padding(.bottom, 8)

            Text("Join us today! Please fill in the information below to create your account.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 30)

            TextField("Email", text: $viewModel.username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)

            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)

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
                PrimaryButton(title: "Sign Up", action: {
                    viewModel.signUp()
                })
            }

            HStack {
                Spacer()
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    navigationStack.pop()
                }) {
                    Text("Login")
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding([.horizontal, .bottom])
        .onReceive(viewModel.$success.dropFirst()) { success in
            if success {
                navigationStack.push(MovieListView())
            }
        }
        .alert(isPresented: $viewModel.showingErrorAlert) {
            Alert(
                title: Text("Sign Up Failed"),
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
    SignUpView()
}
