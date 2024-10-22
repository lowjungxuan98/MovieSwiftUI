//
//  LoginView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                // Action for going back
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
            
            TextField("Email", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Password", text: .constant(""))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            
            Spacer()
            
            PrimaryButton(title: "Login", action: {
                
            })
            
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
    }
}

#Preview {
    SignUpView()
}

