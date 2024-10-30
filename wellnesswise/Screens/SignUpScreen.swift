//
//  SignUpScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/10/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct SignUpScreen: View {
	@StateObject private var viewModel = SignUpViewModel()

	
	var body: some View {
		NavigationStack() {
			VStack() {
				Text("Create account").font(.title2)
				Form{
					Section(header: Text("Personal information")){
						
						StyledTextField(
							title: "Email",
							placeholder: "Enter your email",
							text: $viewModel.email
						)
						StyledTextField(
							title: "Name",
							placeholder: "Enter your full name",
							text: $viewModel.fullName
						)
						StyledTextField(
							title: "Age",
							placeholder: "Please enter your age",
							text: $viewModel.age
						)
						StyledTextField(
							title: "Weight",
							placeholder: "(kg)",
							text: $viewModel.weight,
							isNumber: true
						)
						StyledTextField(
							title: "Height",
							placeholder: "(cm)",
							text: $viewModel.height,
							isNumber: true
						)
						Picker (selection: $viewModel.gender, label : Text ("Gender")) {
							Text("Male").tag("Male")
							Text("Female").tag("Female")
						}.pickerStyle(.palette)
						
						StyledTextField(
							title: "Password",
							placeholder: "Please create strong password",
							text: $viewModel.password,
							isSecure: true
						)
					}
					
				}
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundStyle(.red)
						.font(.footnote)
						.padding()
				}
				Button (action:{
					viewModel.signup()
				}){
					if viewModel.isLoading{
						ProgressView()
					}
					else {
						Text("Create account")
							.font(.subheadline)
							.fontWeight(.semibold)
							.foregroundStyle(.white)
							.frame(width:250, height: 50)
							.background(.black)
							.clipShape(.capsule)
					}
				}
				.disabled(viewModel.isLoading)
				NavigationLink {
					LoginScreen()
				} label:
				{
					Text("Already have account? Login")
						.font(.footnote)
						.fontWeight(.semibold)
				}
			}
			.navigationDestination(isPresented: $viewModel.isSignupSuccessful){
				HomeScreen()
			}
			
		}
		
	}
}
#Preview {
	SignUpScreen()
}
