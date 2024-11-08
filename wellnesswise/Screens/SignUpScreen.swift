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
				.navigationTitle("Create account")
				.toolbar {
					ToolbarItem(placement: .bottomBar) {
						Button (action:{
							viewModel.signup()
						}){
							if viewModel.isLoading{
								ProgressView()
							}
							else {
								Text("Create an account")
									.font(.subheadline)
									.fontWeight(.semibold)
									.foregroundStyle(.white)
									.frame(width:250, height: 50)
									.background(.black)
									.clipShape(.capsule)
							}
						}
						.disabled(viewModel.isLoading)
						
					}
				}
				if !viewModel.errorMessage.isEmpty {
					Text(viewModel.errorMessage)
						.foregroundStyle(.red)
						.font(.footnote)
						.padding()
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
			.navigationDestination(isPresented: $viewModel.isSignupSuccessful){
				HealthDataScreen()
			}
			
		}
		
	}
}
#Preview {
	SignUpScreen()
}
