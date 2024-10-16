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
        VStack {
            Spacer(minLength: 100)
            Image(.whitetheme)
                .frame(width: 200, height: 200, alignment: .center)
           
           
            Form {
                Text("Login")
                    .bold()
                    .font(.title)
                TextField(
                    "Email",
                    text:$email
                )
                SecureField (
                    "Password",
                    text:  $password)
            }
            Button {
                
            }
            label: {
                Text("Login")
            }
            
        }
    }
}

#Preview {
    LoginScreen()
}
