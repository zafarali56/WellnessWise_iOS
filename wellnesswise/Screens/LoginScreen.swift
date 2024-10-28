//
//  LoginScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 11/10/2024.
//

import SwiftUI

struct LoginScreen: View {
	@StateObject private var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Image(.whitetheme)
                    .resizable()
                    .scaledToFit()
				VStack(alignment: .leading){
                    
					StyledTextField(
						title: "Email",
						placeholder: "Please enter your email",
						text: $viewModel.email)
                    
					StyledTextField(
						title: "Password",
						placeholder: "Please enter your password",
						text: $viewModel.password,
						isSecure: true)
                    
                    NavigationLink {
                        Text("Forgot password")
                    } label:{
                        Text("Forgot password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }.textFieldStyle(.roundedBorder).padding()
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundStyle(.red)
						.font(.footnote)
						.padding()
				}
				Button (action:{
					viewModel.login()
				}){
					if viewModel.isLoading {
						ProgressView()
					}
					else{ Text("Login")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
							.frame(width:250, height: 50)
							.background(.black)
							.clipShape(.capsule)
					}
				}.disabled(viewModel.isLoading)
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
				.navigationDestination(
					isPresented: $viewModel.isLoginSuccessful
				){
					HomeScreen()
				}
        }
    }
}

#Preview {
    LoginScreen()
}
