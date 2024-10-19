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
                VStack(alignment: .center){
                    
                    TextField(
                        "Email",
                        text:$email
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.title3)
                    
                    SecureField (
                        "Password",
                        text:  $password
                    )
                    .autocorrectionDisabled(true)
                    .font(.title3)
                    
                    NavigationLink {
                        Text("Forgot password")
                    } label:{
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }.textFieldStyle(.roundedBorder).padding()
                
                Button {
                }
                label: {
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width:250, height: 50)
                        .background(.black)
                        .clipShape(.capsule)
                }
                Spacer()
                NavigationLink {
                    SignUpScreen()
                } label:{
                    Text("Don't have an account? Sign up")
                        .fontDesign(Font.Design.rounded)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }.textFieldStyle(.roundedBorder).padding(25)
        }
    }
}

#Preview {
    LoginScreen()
}
