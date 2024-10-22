//
//  PrimaryButton.swift
//  movie app
//
//  Created by Low Jung Xuan on 22/10/2024.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var backgroundColor: Color = .blue
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
