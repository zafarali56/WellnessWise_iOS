//
//  LoginScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 11/10/2024.
//

import SwiftUI

struct LoginScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Image(.whitetheme)
                    .resizable()
                    .scaledToFit()
                Form{
                    TextField(
                        "Email",
                        text:$email
                    )
                    SecureField (
                        "Password",
                        text:  $password)
                    NavigationLink {
                        Text("Forgot password")
                    } label:{
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                Button {
                }
                label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 350, height: 50)
                        .background(.black)
                        .clipShape(.capsule)
                }
            }
        }
    }
}

#Preview {
    LoginScreen()
}
