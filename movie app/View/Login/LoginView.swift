//
//  LoginView.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("login_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            Text("Access more with an account")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
                .padding(.bottom, 8)
                .padding(.horizontal, 40)

            Text("Login to an account so you could access more features")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
            
            PrimaryButton(title: "Login", action: {
                
            })
            .padding(.horizontal)
            
            Button(action: {
                
            }) {
                Text("Sign Up")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

