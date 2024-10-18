//
//  SignUpScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/10/2024.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var gender = 1
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack() {
            Text("Create account").font(.title2)
            
            VStack() {
                VStack(alignment: .center, spacing: 15){

                    TextField(
                        "Email",
                        text:$email
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .font(.title3)
                    
                    TextField (
                        "Full Name",
                        text:$fullName
                    )
                    .autocorrectionDisabled(true)
                    .font(.title3)
                    
                    
                    TextField (
                        "Age",
                        text: $age
                    )
                    .keyboardType(.numberPad)
                    .font(.title3)
                    
                    TextField (
                        "Weight (kg)",
                        text: $weight
                    )
                    .keyboardType(.numberPad)
                    .font(.title3)
                    
                    TextField (
                        "Height (cm)",
                        text: $height
                    )
                    .keyboardType(.numberPad)
                    .font(.title3)
                    
                    
                    
                    Picker (selection: $gender, label : Text ("Gender")) {
                        Text("Male").tag(1)
                        Text("Female").tag(2)
                    }.pickerStyle(.palette)
                    
                    SecureField(
                        "Create a Password",
                        text: $password
                    )
                    .autocorrectionDisabled(true)
                    .font(.title3)
                    
                    
                    Button {
                        
                    }
                    
                    label: {
                        Text("Create account")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 350, height: 50)
                            .background(.black)
                            .clipShape(.capsule)
                    }
                    
                }.textFieldStyle(.roundedBorder).padding(25)
                Spacer()
                
            }
            NavigationLink {
                LoginScreen()
            } label:
            {
                Text("Already have account? Login")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
            }
        }
        
    }
}

#Preview {
    SignUpScreen()
}
